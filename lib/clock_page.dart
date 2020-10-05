import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  ScrollController _controller;
  int countdown = 25;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: 538.56,
    );
    _controller.addListener(() {
      double scrollValue = _controller.offset;
      double minuteValue = (scrollValue / 20);
      //debugPrint('MinuteValue: $minuteValue');
      //
      double clockValue = 0;
      clockValue = (minuteValue + 1) % 68;
      clockValue -= 3;

      setState(() {
        countdown = clockValue.round();
      });
    });
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
              countdown.toString(),
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: double.infinity,
              height: 300.0,
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: Constants.minutes.length,
                itemBuilder: (context, int index) {
                  return MyContainer(
                    minutes: Constants.minutes,
                    index: (index + 1) % Constants.minutes.length,
                    minutesLength: Constants.minutes.length,
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _controller.animateTo(47.622,
                    duration: Duration(seconds: countdown),
                    curve: Curves.easeIn);
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
}

class MyContainer extends StatelessWidget {
  const MyContainer(
      {Key key,
      @required this.minutes,
      @required this.index,
      this.minutesLength})
      : super(key: key);

  final List<String> minutes;
  final int index;
  final minutesLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50.0,
            width: 5.0,
            color: Colors.teal,
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            height: 50.0,
            width: 5.0,
            color: Colors.teal,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150.0,
                width: 10.0,
                color: Colors.teal,
              ),
              Text(
                minutes[index.abs()].toString(),
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
          Container(
            height: 50.0,
            width: 5.0,
            color: Colors.teal,
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            height: 50.0,
            width: 5.0,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
