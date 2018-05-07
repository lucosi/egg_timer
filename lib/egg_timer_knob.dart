import 'dart:math';

import 'package:flutter/material.dart';

class EggTimerDialKnob extends StatefulWidget {
  final rotationPercent;

  const EggTimerDialKnob({this.rotationPercent});

  @override
  _EggTimerDialKnobState createState() => new _EggTimerDialKnobState();
}

final Color gradientTop = const Color(0xFFF5F5F5);
final Color gradientBotton = const Color(0xFFE8E8EB);

class _EggTimerDialKnobState extends State<EggTimerDialKnob> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        new Container(
          width: double.infinity,
          height: double.infinity,
          child: new CustomPaint(
            painter: new ArrowPainter(
              rotationPercent: widget.rotationPercent,
            ),
          ),
        ),
        new Container(
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
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0.0, 3.0),
                )
              ]),
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: const Color(0xFFDFDFDF),
                    width: 1.5,
                  )),
              child: new Center(
                child: new Transform(
                  transform: new Matrix4.rotationZ(2 * pi * widget.rotationPercent),
                  alignment: Alignment.center,
                  child: new Image.network(
                    'https://avatars1.githubusercontent.com/u/14101776?s=200&v=4',
                    width: 50.0,
                    height: 50.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final double rotationPercent;

  ArrowPainter({this.rotationPercent}) : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final radius = size.height / 2;
    canvas.translate(radius, radius);
    canvas.rotate(2 * pi * rotationPercent);

    Path path = new Path();
    path.moveTo(0.0, -radius - 10.0);
    path.lineTo(10.0, -radius + 5.0);
    path.lineTo(-10.0, -radius + 5.0);
    path.close();

    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.black, 3.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}