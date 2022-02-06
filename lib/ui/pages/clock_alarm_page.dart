import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:alarm_clock/ui/widgets/hour_hand_clock.dart';
import 'package:alarm_clock/ui/widgets/minute_hand_clock.dart';
import 'package:alarm_clock/ui/widgets/wheel_clock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClockAlarmPage extends StatelessWidget {
  const ClockAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.green.shade900,
          onPressed: () {
            controller.addToList(isActive: true);
            controller.setNotification();
          },
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  bottom: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.setAmPm(true);
                          },
                          child: Card(
                              color: Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 24),
                              elevation: 5,
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'AM',
                                  style: controller.isAm.value
                                      ? const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        )
                                      : const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.setAmPm(false);
                          },
                          child: Card(
                              color: Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 24),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'PM',
                                  style: !controller.isAm.value
                                      ? const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 24,
                                        )
                                      : const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.grey,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * .8,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Center(
                        child: CustomPaint(painter: WheelClock()),
                      ),
                    ),
                    const Align(
                      alignment: Alignment(0, 0),
                      child: MinuteHandClock(),
                    ),
                    const Align(
                      alignment: Alignment(0, 0),
                      child: HourHandClock(),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        () {
                          var hour = '';
                          var minute = '';

                          hour = controller.hour < 10
                              ? '0${controller.hour}'
                              : controller.hour.toString();

                          minute = controller.minute < 10
                              ? '0${controller.minute}'
                              : controller.minute.toString();

                          return '$hour:$minute';
                        }(),
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
