import 'dart:math';

import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinuteHandClock extends StatefulWidget {
  const MinuteHandClock({Key? key}) : super(key: key);

  @override
  _MinuteHandClockState createState() => _MinuteHandClockState();
}

class _MinuteHandClockState extends State<MinuteHandClock>
    with SingleTickerProviderStateMixin {
  final ClockController _dx = Get.find();
  double degree = 0;
  int _valueChoose = 0;
  late double radius;
  late AnimationController ctrl;
  List<Color> colors = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.red,
    Colors.red,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    radius = _dx.wheelSize / 2;
    ctrl = AnimationController.unbounded(vsync: this);
    degree = _dx.minDegree.value;
    ctrl.value = degree;
    for (var i = 0; i < 5; i++) {}
  }

  double roundToBase(double number, int base) {
    double check = number % base;
    double result = number;
    if (check < (base / 2)) {
      result = number - check;
    } else {
      result = number + (base - check);
    }
    return result;
  }

  double degreeToMiniute(double degree) {
    return (degree / 60) * 10;
  }

  _onPanUpdate(DragUpdateDetails detail) {
    bool onTop = detail.localPosition.dy <= radius;
    bool onLeftSide = detail.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = detail.delta.dy <= 0.0;
    bool panLeft = detail.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = detail.delta.dy.abs();
    double xChange = detail.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange = verticalRotation + horizontalRotation;

    double _value = degree + (rotationalChange / 5);

    setState(() {
      degree = _value > 0 ? _value : 0;

      // set the clock hand degree so if the clock hands
      // rotate through the much one rotation the degree is always
      // no longer than 360 and the minute is no longer than 60
      degree = degree.roundToDouble() == 360 ? 0 : degree;
      ctrl.value = degree;
      var a = degree < 360 ? degree.roundToDouble() : degree - 360;

      var degrees = _dx.roundToBase(a.roundToDouble(), 10);

      // make the clock hand point the right hour,
      // 60 * 6 (60 minutes format) = 360
      _valueChoose = degrees ~/ 6 == 60 ? 0 : degrees ~/ 6;

      _dx.setMinute(_valueChoose.round());
      _dx.minDegree.value = degrees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockController>(builder: (controller) {
      return GestureDetector(
        onPanUpdate: (detail) {
          _onPanUpdate(detail);
        },
        child: SizedBox(
          height: double.parse(controller.wheelSize.toString()),
          width: double.parse(controller.wheelSize.toString()),
          child: Center(
            child: AnimatedBuilder(
              animation: ctrl,
              builder: (ctx, w) {
                return Transform.rotate(
                  angle: ctrl.value * (pi / 180),
                  child: Container(
                    width: 10,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.topCenter,
                        colors: colors,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
