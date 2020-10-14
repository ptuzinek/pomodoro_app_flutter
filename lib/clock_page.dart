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
  int selectedNumber = 25;
  int seconds = 60;
  Timer timer;
  int minutes = 25;
  bool isPaused = true;
  ScrollPhysics physics = FixedExtentScrollPhysics();
  int secondsLeft = 1;
  int secondsSumCountDown = 1;
  int roundsDone = 4;
  int goal = 0;
  int listViewItemPosition = 24;
  double progress = 1;
  bool isCountdownStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: 24,
    );
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
              height: 20.0,
            ),
            Text(
              displayTime(),
              style: TextStyle(
                fontSize: 80.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                onListWheelTap();
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
                      reloadCircularProgressIndicator();
                      secondsSumCountDown = 1;
                      secondsLeft = secondsSumCountDown;
                      isCountdownStarted = false;
                      setState(() {
                        isPaused = true;
                      });
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
                        listViewItemPosition = value;
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
              height: 15,
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: isPaused ? Icon(Icons.play_arrow) : Icon(Icons.pause),
                    onPressed: () {
                      onListWheelTap();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Container(
              color: Colors.white70,
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ROUND',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              roundsDone < 4
                                  ? roundsDone.toString()
                                  : (roundsDone - 4).toString(),
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/4',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 1,
                    color: Colors.grey[800],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'GOAL',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              roundsDone.toString(),
                              //textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/12',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onListWheelTap() {
    if (timer != null) {
      timer.cancel();
    }
    if (isPaused == false) {
      setState(() {
        isPaused = true;
      });
    } else {
      physics = AlwaysScrollableScrollPhysics();
      startTimer(seconds, minutes);
      turnTheClock();
      setState(() {
        isPaused = false;
      });
    }
  }

  String displayTime() {
    //
    if (seconds == 60) {
      return '$minutes:00';
    } else if (minutes > 9 && seconds > 9) {
      return '$minutes:$seconds';
    } else if (minutes < 10 && seconds < 10) {
      return '0$minutes:0$seconds';
    } else if (minutes < 10 && seconds > 9) {
      return '0$minutes:$seconds';
    } else if (minutes > 9 && seconds < 10) {
      return '$minutes:0$seconds';
    }
  }

  //
  void turnTheClock() {
    _controller.animateToItem((listViewItemPosition - selectedNumber),
        duration: Duration(
          minutes: selectedNumber,
        ),
        curve: Curves.linear);
  }

  void startTimer(int secondCount, int minutesCount) {
    minutes = minutesCount;
    seconds = secondCount;
    if (!isCountdownStarted) {
      secondsSumCountDown = minutes * 60;
      secondsLeft = secondsSumCountDown;
    }

    isCountdownStarted = true;

    if (timer != null) {
      timer.cancel();
    }

    if (secondsSumCountDown != 0) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        bool lastSecond = false;

        setState(() {
          progress = secondsLeft / secondsSumCountDown;
          if (minutes == 0 && seconds == 0) {
            roundsDone++;
            timer.cancel();
            reloadCircularProgressIndicator();
            secondsSumCountDown = 1;
            secondsLeft = 1;
          } else if (seconds == 60 || (seconds == 0 && minutes != 0)) {
            minutes--;
            seconds--;
            secondsLeft--;
            lastSecond = true;
          } else if (!lastSecond) {
            seconds--;
            secondsLeft--;
          }
          seconds = (seconds) % 60;
        });
      });
    } else {
      secondsSumCountDown = 1;
      secondsLeft = 1;
    }
  }

  void reloadCircularProgressIndicator() {
    progress = secondsLeft / secondsSumCountDown;
    double increment = 0.001;
    timer = Timer.periodic(Duration(microseconds: 1), (timer) {
      setState(() {
        if (progress < 1.0) {
          increment += 0.0001;
          progress += increment;
        } else {
          timer.cancel();
        }
      });
    });
  }
}
