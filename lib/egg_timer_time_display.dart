import 'package:egg_timer/egg_timer.dart';
import 'package:flutter/material.dart';


class EggTimerDisplay extends StatefulWidget {
  
  final eggTimeState;
  final selectionTime;
  final countDownTime;

  EggTimerDisplay({
    this.eggTimeState,
    this.selectionTime = const Duration(minutes: 0),
    this.countDownTime = const Duration(minutes: 0),
  });

  @override
  _EggTimerDisplayState createState() => new _EggTimerDisplayState();
}

class _EggTimerDisplayState extends State<EggTimerDisplay> with TickerProviderStateMixin {

  get formatedTime {
      DateTime time = DateTime(000, 0, 0, 0, 0, widget.countDownTime.inSeconds);
      String min;
      String sec;
      if (time.minute < 10) {
        min = '0${time.minute}'; 
      } else {
        min = '${time.minute}';
      }
      if (time.second < 10) {
        sec = '0${time.second}'; 
      } else {
        sec = '${time.second}';
      }
      return '$min:$sec';
      // return '${time.minute.floor()}:${time.second.toDouble().toInt()}';
 }

 get formatedTimeMin {
      DateTime time = DateTime(000, 0, 0, 0, 0, widget.countDownTime.inSeconds);
      String min;
      if (time.minute < 10) {
        min = '0${time.minute}'; 
      } else {
        min = '${time.minute}';
      }
      return '$min';
      // return '${time.minute.floor()}:${time.second.toDouble().toInt()}';
 }

  AnimationController selectionTimeSlideController;
  AnimationController coutDownTimeFadeController;

  @override
  void initState() {
    super.initState();

    selectionTimeSlideController = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )
    ..addListener(() {
      setState(() { });
    }); 

    coutDownTimeFadeController = new AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    ) 
    ..addListener(() {
      setState(() { });
    });
    coutDownTimeFadeController.value = 1.0;
  }

  @override
  void dispose() {
    selectionTimeSlideController.dispose();
    coutDownTimeFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eggTimeState == EggTimerState.ready) {
      selectionTimeSlideController.reverse();
      coutDownTimeFadeController.forward();
    } else {
      selectionTimeSlideController.forward();
      coutDownTimeFadeController.reverse();
    }

    return new Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: new Stack(
        alignment: Alignment.center,
        children: [
          new Transform(
            transform: new Matrix4.translationValues(
              0.0,
              -200.0 * selectionTimeSlideController.value, 
              0.0),
            child: new Text(
              formatedTimeMin,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 120.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0),
            ),
          ),
          new Opacity(
            opacity: 1.0 - coutDownTimeFadeController.value,
            child: new Text(
              formatedTime,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 120.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5.0),
            ),
          ),
        ],
      ),
    );
  }
}


