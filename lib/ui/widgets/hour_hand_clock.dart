import 'dart:math';

import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HourHandClock extends StatefulWidget {
  const HourHandClock({Key? key}) : super(key: key);

  @override
  _HourHandClockState createState() => _HourHandClockState();
}

class _HourHandClockState extends State<HourHandClock>
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
    Colors.green.shade900,
    Colors.green.shade900,
    Colors.green.shade900,
  ];

  @override
  void initState() {
    super.initState();
    radius = _dx.wheelSize / 2;
    ctrl = AnimationController.unbounded(vsync: this);
    degree = _dx.hourDegree.value;
    ctrl.value = degree;
  }

  _onPanUpdate(DragUpdateDetails detail) {
    // detect pan gesture location on the clock
    bool onTop = detail.localPosition.dy <= radius;
    bool onLeftSide = detail.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    // block the anticlock movement if the degree in 0
    bool panUp = detail.delta.dy <= 0.0;
    bool panLeft = detail.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    // change on axis set to be absolute
    // so the hand clock could be move
    double yChange = detail.delta.dy.abs();
    double xChange = detail.delta.dx.abs();

    // directional change on the clock
    // check if the gesture on left or right
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // total computed change
    double rotationalChange = verticalRotation + horizontalRotation;

    double _value = degree + (rotationalChange / 5);

    setState(() {
      // because the clock hand will not move the anticlockwise
      // than the degree must be 0
      degree = _value > 0 ? _value : 0;

      // set the clock hand degree so if the clock hands
      // rotate through the much one rotation the degree is always
      // no longer than 360 and the hour is no longer than 12
      degree = degree.roundToDouble() == 360 ? 0 : degree;

      ctrl.value = degree;
      var a = degree < 360 ? degree.roundToDouble() : degree - (360);
      // return to decimal base (10)
      var degrees = _dx.roundToBase(a.roundToDouble(), 10);

      // make the clock hand point the right hour,
      // 30 * 12 (12 hours format) = 360
      _valueChoose = degrees ~/ 30 == 12 ? 0 : degrees ~/ 30;

      _dx.setHour(_valueChoose.round());
      _dx.hourDegree.value = degrees;
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
                    width: 9,
                    height: 180,
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
