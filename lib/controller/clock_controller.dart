import 'dart:async';

import 'package:alarm_clock/models/alarm.dart';
import 'package:alarm_clock/utils/notification_util.dart';
import 'package:get/get.dart';

class ClockController extends GetxController {
  var wheelSize = 300;
  var minute = 0.obs;
  var hour = 0.obs;
  var hourDegree = 0.0.obs;
  var minDegree = 0.0.obs;
  var alarms = <Alarm>[].obs;
  var isAm = true.obs;

  double roundToBase(double number, int base) {
    double reminder = number % base;
    double result = number;
    if (reminder < (base / 2)) {
      result = number - reminder;
    } else {
      result = number + (base - reminder);
    }
    return result;
  }

  setHour(int h) {
    hour.value = h;
    update();
  }

  setMinute(int m) {
    minute.value = m;
    update();
  }

  setAmPm(bool value) {
    isAm.value = value;
    update();
  }

  StreamSubscription<String?> listenNotification() {
    return NotificationUtil.onNotification.stream.listen(handleNotification);
  }

  void handleNotification(String? payload) {}

  addToList({bool? isActive}) {
    if (alarms.length <= 10) {
      int id = int.parse('${hour.value}${minute.value}');

      Alarm a = Alarm(
          id: id,
          dateTime: getDateTime(),
          hour: hour.value,
          minute: minute.value,
          isAm: isAm.value,
          isActive: isActive ?? true);
      alarms.add(a);

      update();
    } else {
      Get.snackbar('Alert!', "You can't add more than 10 alarms ");
    }
  }

  removeAlarm(Alarm alarm) {
    alarms.remove(alarm);
    update();
  }

  removeAlarmById(int id) {
    alarms.removeWhere((element) => element.id == id);
    update();
  }

  cancelAlarm(Alarm alarm) {
    int id = int.parse('${alarm.hour}${alarm.minute}');
    NotificationUtil.cancelAlarm(id);
  }

  cancelAllAlarm() async {
    await NotificationUtil.cancelAllAlarm();
  }

  DateTime getDateTime() {
    DateTime now = DateTime.now();
    var date = DateTime(now.year, now.month, () {
      if (now.hour > (isAm.value ? hour.value : hour.value + 12)) {
        return now.day + 1;
      } else {
        if (now.hour == (isAm.value ? hour.value : hour.value + 12) &&
            now.minute >= minute.value &&
            now.second > 0) {
          return now.day + 1;
        } else {
          return now.day;
        }
      }
    }(), isAm.value ? hour.value : hour.value + 12, minute.value);

    return date;
  }

  Iterable<Alarm> getItem(int id) => alarms.where((p0) => p0.id == id);

  setNotification() {
    int id = int.parse('${hour.value}${minute.value}');
    NotificationUtil.showNotification(
        id: id,
        title: '⏳',
        body: "It's your time to shine!!",
        payload: id.toString(),
        time: getDateTime());
  }
}
