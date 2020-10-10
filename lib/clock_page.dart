import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CustomWheelScrollView.dart';
import 'constants.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  FixedExtentScrollController _controller;
  int countdown = 25;
  int selectedNumber = 25;
  int seconds = 60;
  Timer timer;
  int minutes = 25;
  bool isPaused = true;
  ScrollPhysics physics = FixedExtentScrollPhysics();

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: 24,
    );

    _controller.addListener(() {
      // seconds = _controller.offset.round().abs() + 40;
      // seconds = (seconds * 1.5).round();
      // setState(() {
      //   seconds = (seconds) % 60;
      // });
      //
      // print(seconds);
    });

    // _controller.addListener(() {
    //   double scrollValue = _controller.offset;
    //   double minuteValue = (scrollValue / 20);
    //   //debugPrint('MinuteValue: $minuteValue');
    //   //
    //   double clockValue = 0;
    //   clockValue = (minuteValue + 1) % 68;
    //   clockValue -= 3;
    //
    //   setState(() {
    //     countdown = clockValue.round();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pomodoro Timer',
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Text(
              displayTime(),
              style: TextStyle(
                fontSize: 40.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (timer != null) {
                  timer.cancel();
                }
                if (isPaused == false) {
                  isPaused = true;
                } else {
                  physics = AlwaysScrollableScrollPhysics();
                  startTimer(seconds, minutes);
                  turnTheClock();
                  isPaused = false;
                }
              },
              child: Container(
                height: 200.0,
                width: 600.0,
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    physics = FixedExtentScrollPhysics();
                    if (timer != null) {
                      timer.cancel();
                      minutes = selectedNumber;
                      seconds = 0;
                    }
                    return true;
                  },
                  child: ListWheelScrollViewX(
                    scrollDirection: Axis.horizontal,
                    physics: physics,
                    controller: _controller,
                    itemExtent: 40,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedNumber = (value + 1) % 60;
                        minutes = (value + 1) % 60;
                        //print(value);
                      });
                    },
                    builder: (context, index) {
                      index = (index + 1) % 60;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: index % 5 == 0 ? 90.0 : 30,
                            width: 3.0,
                            color: Colors.white,
                          ),
                          Text(
                            index % 5 == 0 ? index.abs().toString() : '',
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                physics = AlwaysScrollableScrollPhysics();
                turnTheClock();
                startTimer(seconds, minutes);
              },
              child: Text(
                'START',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String displayTime() {
    //
    if (seconds == 60) {
      return '$minutes:00';
    } else
      return '$minutes:$seconds';
  }

  //
  void turnTheClock() {
    _controller.animateToItem(-1,
        duration: Duration(
          minutes: selectedNumber,
        ),
        curve: Curves.linear);
  }

  void startTimer(int secondCount, int minutesCount) {
    minutes = minutesCount;
    seconds = secondCount;

    if (timer != null) {
      timer.cancel();
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds == 60 || seconds == 0) {
          minutes--;
        }
        if (minutes > 0) {
          seconds--;
          seconds = (seconds) % 60;
        } else {
          timer.cancel();
        }
      });
    });
  }
}
