import 'dart:math';
import 'package:egg_timer/egg_timer_knob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';


final Color gradientTop = const Color(0xFFF5F5F5);
final Color gradientBotton = const Color(0xFFE8E8EB);

@override
class EggTimerDial extends StatefulWidget {
  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  EggTimerDial({
    this.currentTime = const Duration(minutes: 0),
    this.maxTime,
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  _EggTimerDialState createState() => new _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> {
  _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: new Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: new AspectRatio(
          aspectRatio: 1.0,
          child: new GestureRecognizeState(
            maxTime: widget.maxTime,
            currentTime: widget.currentTime,
            onTimeSelected: widget.onTimeSelected,
            onDialStopTurning: widget.onDialStopTurning,
            child: new Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [gradientTop, gradientBotton],
                  ),
                  boxShadow: [
                    new BoxShadow(
                      color: const Color(0x44000000),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                      offset: const Offset(0.0, 1.0),
                    )
                  ]),
              child: new Stack(
                children: [
                  new Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(55.0),
                    child: new CustomPaint(
                      painter: new TickPainter(
                        tickCount: widget.maxTime.inMinutes,
                        ticksPerSection: widget.ticksPerSection,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(65.0),
                    child: new EggTimerDialKnob(
                        rotationPercent: _rotationPercent()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GestureRecognizeState extends StatefulWidget {

  final child;
  final Duration currentTime;
  final Duration maxTime;
  final onTimeSelected;
  final onDialStopTurning;


  GestureRecognizeState({
    this.child,
    this.currentTime,
    this.maxTime,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _GestureRecognizeStateState createState() =>
      new _GestureRecognizeStateState();
}

class _GestureRecognizeStateState extends State<GestureRecognizeState> {

  double startAngle;

  Duration startTime;
  Duration currentTimeTmp;
  Duration clockTime;

// Calculete the angle
  _conculateAngle(Offset point, Size size) {
    final double r = size.width / 2;
    num ax = r - point.dx;
    num ay = r - point.dy;
    final angle = atan2(ax, ay) * 180 / pi;
    if (angle < 0) {
      return (atan2(ax, ay) * 180 / pi) * -1;
    } else {
      return 360 - (atan2(ax, ay) * 180 / pi);
    }
  }


  @override
  Widget build(BuildContext context) {

    return new GestureDetector(

      child: widget.child,

      onPanStart: (DragStartDetails pan) {
        RenderBox getBox = context.findRenderObject();
        var local = getBox.globalToLocal(pan.globalPosition);
        startAngle = _conculateAngle(local, getBox.size);
        startTime = widget.currentTime;
      },

      onPanUpdate: (DragUpdateDetails pan) {
        RenderBox getBox = context.findRenderObject();
        var local = getBox.globalToLocal(pan.globalPosition);
        final time = _conculateAngle(local, getBox.size);
        if (time != Null) {
          final angleDiff = time - startAngle;
          final timeDiffInSeconds = (angleDiff * (2 * pi)).round();
          currentTimeTmp = new Duration(seconds: startTime.inSeconds + timeDiffInSeconds);
          clockTime = Duration(minutes: currentTimeTmp.inMinutes.round()); 
          widget.onTimeSelected(clockTime);
        }
      },

      onPanEnd: (DragEndDetails pan) {
        widget.onDialStopTurning(clockTime);
        startAngle = null;
        currentTimeTmp = null;
        startTime = null;
      },
    );
  }
}


class TickPainter extends CustomPainter {

  final longTick = 14.0;
  final shortTick = 4.0;

  final tickCount;
  final ticksPerSection;
  final ticksInsert;
  final tickPaint;
  final textPainter;
  final textStyle;

  TickPainter({
    this.tickCount,
    this.ticksPerSection,
    this.ticksInsert = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;
    for (var i = 0; i < tickCount; ++i) {
      final tickLength = i % ticksPerSection == 0 ? longTick : shortTick;
      canvas.drawLine(
        new Offset(0.0, -radius),
        new Offset(0.0, -radius - tickLength),
        tickPaint,
      );

      if (i % ticksPerSection == 0) {
        // paint text
        canvas.save();
        canvas.translate(0.0, -(size.width / 2) - 30.0);

        textPainter.text = new TextSpan(
          text: '$i',
          style: textStyle,
        );

        //Layout the text
        textPainter.layout();

        // Figure out witch quadrant the text is in
        final tickPercent = i / tickCount;

        var quadrant;

        if (tickPercent < 0.25) {
          quadrant = 1;
        } else if (tickPercent < 0.5) {
          quadrant = 4;
        } else if (tickPercent < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }

        switch (quadrant) {
          case 4:
            canvas.rotate(-pi / 2);
            break;

          case 2:

          case 3:
            canvas.rotate(pi / 2);
            break;
        }

        textPainter.paint(
          canvas,
          new Offset(
            -textPainter.width / 2,
            -textPainter.height / 2,
          ),
        );

        canvas.restore();
      }

      canvas.rotate(2 * pi / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
