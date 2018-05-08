import 'package:egg_timer/egg_timer.dart';
import 'package:egg_timer/egg_timer_button.dart';
import 'package:flutter/material.dart';

class EggTimerControls extends StatefulWidget {
  final eggTimerState;
  final Function() onPause;
  final Function() onResume;
  final Function() onRestart;
  final Function() onReset;

  EggTimerControls({
    this.eggTimerState,
    this.onPause,
    this.onReset,
    this.onRestart,
    this.onResume,
  });

  @override
  _EggTimerControlsState createState() => new _EggTimerControlsState();
}

class _EggTimerControlsState extends State<EggTimerControls> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        new Opacity(
          opacity: 1.0,
          child: new Row(
            children: [
              new EggTimerButton(
                icon: Icons.refresh,
                text: 'RESTAT',
                onPressed: widget.onRestart,
              ),
              new Expanded(child: new Container()),
              new EggTimerButton(
                icon: Icons.arrow_back,
                text: 'RESET',
                onPressed: widget.onReset,
              ),
            ],
          ),
        ),
        new Transform(
          transform: new Matrix4.translationValues(0.0, 0.0, 0.0),
          child: new EggTimerButton(
            icon: widget.eggTimerState == EggTimerState.running
                ? Icons.pause
                : Icons.play_arrow,
            text: widget.eggTimerState == EggTimerState.running
                ? 'PAUSE'
                : 'RESUME',
            onPressed: widget.eggTimerState == EggTimerState.running
                ? widget.onPause
                : widget.onResume,
          ),
        ),
      ],
    );
  }
}
