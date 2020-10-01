import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  void initState() {
    super.initState();
    holder = ViewHolder(value: 0.55);
    _controller = InfiniteScrollController();
    _controller.addListener(() {
      holder.setValue(_controller.offset / 100.0);
    });
  }

  List<String> minutes = ['5', '10', '15', '20', '25', '30', '35', '40'];

  // TODO - create horizontal ListView with control property of ScrollControl.offset to keep track of the element index and use Transform widget to rotate in 3D
  // TODO 1. https://www.youtube.com/watch?v=2RPl7rwYjnQ
  // TODO 2. https://youtu.be/9z_YNlRlWfA?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG&t=50

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ViewHolder>.value(
        value: holder,
        child: InfiniteListView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          //itemCount: cities.length,
          itemBuilder: (context, int index) {
            return MyContainer(
              cities: minutes,
              index: (index + 1) % minutes.length,
              fraction: fraction,
            );
          },
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer(
      {Key key, @required this.cities, @required this.index, this.fraction})
      : super(key: key);

  final List<String> cities;
  final int index;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<ViewHolder>(context).value;
    debugPrint('$value');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(value / 2.0),
        alignment: FractionalOffset.center,
        child: Container(
          height: 50,
          width: 100,
          color: Colors.teal,
          child: Text(cities[index.abs()]),
        ),
      ),
    );
  }
}
