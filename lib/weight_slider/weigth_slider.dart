import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class WeightSliderScreen extends StatefulWidget {
  const WeightSliderScreen({super.key});

  @override
  State<WeightSliderScreen> createState() => _WeightSliderScreenState();
}

class _WeightSliderScreenState extends State<WeightSliderScreen> {
  late ScrollController scrollController;
  int value = 50;

  @override
  void initState() {
    scrollController =
        ScrollController(initialScrollOffset: (value - 10) * 300 / 3);

    super.initState();
  }

  indexToValue(int index) => 10 + (index - 1);

  int offsetToMiddleIndex(double offset) =>
      ((offset + 300 / 2) ~/ 300 / 3).round();

  offsetToMiddle(double offset) {
    int indexOfMiddle = offsetToMiddleIndex(offset);
    int middle = indexToValue(indexOfMiddle);
    middle = max(10, min(100, middle));
    return middle;
  }

  bool userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  animateTo(int valueToSelect, {int durationMillis = 200}) {
    double target = (valueToSelect - 10) * 300 / 3;
    scrollController.animateTo(target,
        duration: Duration(milliseconds: durationMillis),
        curve: Curves.decelerate);
  }

  bool onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = offsetToMiddle(notification.metrics.pixels);
      if (userStoppedScrolling(notification)) {
        animateTo(middleValue);
      }
      if (middleValue != value) {
        setState(() {
          value = middleValue;
        });
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = (100 - 10) + 3;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        height: 200,
        width: 100,
        color: Colors.transparent,
        child: NotificationListener(
          onNotification: onNotification,
          child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemExtent: 300 / 3,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                int itemValue = indexToValue(index);
                bool isExtra = index == 0 || index == itemCount - 1;
                return isExtra
                    ? Container()
                    : GestureDetector(
                        onTap: () {},
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(itemValue.toString(),
                              style: itemValue == value
                                  ? const TextStyle(fontSize: 28.0)
                                  : const TextStyle(fontSize: 14)),
                        ),
                      );
              }),
        ),
      )),
    );
  }
}
