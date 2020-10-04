import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:pomodoro_app_flutter/view_holder.dart';
import 'package:provider/provider.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  ViewHolder holder;
  InfiniteScrollController _controller;
  double fraction = 0.5;
  String minute = '25';

  List<String> minutes = [
    '00',
    '05',
    '10',
    '15',
    '20',
    '25',
    '30',
    '35',
    '40',
    '45',
    '50',
    '55',
  ];

  @override
  void initState() {
    super.initState();
    holder = ViewHolder(value: 3);
    _controller = InfiniteScrollController(
      initialScrollOffset: 244.622,
    );
    _controller.addListener(() {
      double scrollValue = _controller.offset;
      double minuteValue = (scrollValue / 20.2);
      debugPrint('MinuteValue: $minuteValue');
      holder.setValue(minuteValue);
      //
      double clockValue = 0;
      if (minuteValue < 46 && minuteValue > -1) {
        clockValue = (minuteValue + 1) % 47;
        clockValue += 12;
      } else if (minuteValue > 46) {
        clockValue = minuteValue - 47;
        clockValue = (clockValue + 1) % 59;
      } else if (minuteValue < -1) {
        clockValue = minuteValue - 48;
        clockValue = (clockValue + 1) % 59;
      }

      //
      int minuteValueRound = minuteValue.round();
      int minuteIndex = (minuteValueRound + 1) % minutes.length + 2;
      if (minuteIndex > 11) {
        minuteIndex = (minuteValueRound + 1) % minutes.length;
      }
      setState(() {
        minute = clockValue.toStringAsFixed(0);
        //minute = (minutes[(minuteIndex)]).toString();
      });
    });
  }

  // TODO - create horizontal ListView with control property of ScrollControl.offset to keep track of the element index and use Transform widget to rotate in 3D
  // TODO 1. https://www.youtube.com/watch?v=2RPl7rwYjnQ
  // TODO 2. https://youtu.be/9z_YNlRlWfA?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG&t=50

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ViewHolder>.value(
        value: holder,
        child: Column(
          children: [
            Text(
              minute,
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: double.infinity,
              height: 300.0,
              child: InfiniteListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                //itemCount: cities.length,
                itemBuilder: (context, int index) {
                  return MyContainer(
                    minutes: minutes,
                    index: (index + 1) % minutes.length,
                    fraction: fraction,
                    minutesLength: minutes.length,
                  );
                },
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
      this.fraction,
      this.minutesLength})
      : super(key: key);

  final List<String> minutes;
  final int index;
  final double fraction;
  final minutesLength;

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<ViewHolder>(context).value;

    value = (value + 1) % minutesLength;

    if (value > 8.2 && index < 4) {
      value = value - value / 1.05;
    }
    if (value < 1 && index == 11) {
      value = value + 9;
    }
    int diff = (index - value.round());
    //debugPrint('index: $index');
    //debugPrint('value: $value');
    //debugPrint('diff:  $index - $value =  $diff');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      //child: Transform(
      //  transform: Matrix4.identity()
      //    ..setEntry(3, 2, 0.001)
      //    ..rotateY(-diff / 10),
      //  alignment: FractionalOffset.center,
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
      //),
    );
  }
}
