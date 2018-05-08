import 'dart:io';

import 'package:egg_timer/egg_timer.dart';
import 'package:egg_timer/egg_timer_controls.dart';
import 'package:egg_timer/egg_timer_dial.dart';
import 'package:egg_timer/egg_timer_time_display.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';


final Color gradientTop = const Color(0xFFF5F5F5);
final Color gradientBotton = const Color(0xFFE8E8EB);

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  EggTimer eggTimer;

  _MyAppState() {
    eggTimer = new EggTimer(
      maxTime: const Duration(minutes: 35),
      onTimeUpdate: _onTimeUpdate,
    );
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      if (newTime.inSeconds >= 0) {
        eggTimer.currentTime = newTime;
      } else if (newTime.inSeconds > eggTimer.maxTime.inSeconds) {
        eggTimer.currentTime = Duration(seconds: 0);
      }
    });
  }

  _onTimeUpdate() {
    setState(() {});
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      if (newTime != null) {
        eggTimer.currentTime = newTime;
      }
      eggTimer.resume();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Egg Timer',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            Platform.isAndroid ? 'Android Device' : 'iOS Decvice',
            ),
        
        ),
        body: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [gradientTop, gradientBotton],
          )),
          child: new Center(
            child: new Column(
              children: [
                new EggTimerDisplay(
                  eggTimeState: eggTimer.state,
                  selectionTime: eggTimer.lastStartTime,
                  countDownTime: eggTimer.currentTime,
                ),
                new EggTimerDial(
                  currentTime: eggTimer.currentTime,
                  maxTime: eggTimer.maxTime,
                  ticksPerSection: 5,
                  onTimeSelected: _onTimeSelected,
                  onDialStopTurning: _onDialStopTurning,
                ),
                new Expanded(child: new Container()),
                new EggTimerControls(
                  eggTimerState: eggTimer.state,
                  onPause: () {
                    setState(() => eggTimer.pause());
                  },
                  onResume: () {
                    setState(() => eggTimer.resume());
                  },
                  onReset: () {
                    setState(() => eggTimer.reset());
                  },
                  onRestart: () {
                    setState(() => eggTimer.restart());
                  },
                ),
                new Container(
                  width: double.infinity,
                  color: const Color.fromARGB(10, 1000, 1000, 1000),
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
