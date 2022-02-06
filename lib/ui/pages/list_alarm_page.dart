import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ListAlarmPage extends StatelessWidget {
  const ListAlarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockController>(builder: (controller) {
      return controller.alarms.isEmpty
          ? noAlarm()
          : Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(controller.alarms.length, (index) {
                    var item = controller.alarms[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade700,
                              Colors.grey.shade800,
                              Colors.grey.shade900,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.alarm,
                                color: Colors.white,
                                size: 46,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                () {
                                  var hour = '';
                                  var minute = '';
                                  var am = 'am';

                                  hour = item.hour < 10
                                      ? '0${item.hour}'
                                      : item.hour.toString();

                                  minute = item.minute < 10
                                      ? '0${item.minute}'
                                      : item.minute.toString();

                                  am = item.isAm ? 'AM' : 'PM';

                                  return '$hour:$minute $am';
                                }(),
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  controller.removeAlarm(item);
                                  controller.cancelAlarm(item);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 36,
                                ),
                              )
                            ],
                          ),
                        ), //declare your widget here
                      ),
                    );
                  }),
                ),
              ),
            );
    });
  }

  Widget noAlarm() {
    return Center(
      child: Text(
        "There is no alarm is set 😢",
        style: TextStyle(
          color: Colors.grey.shade900,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
