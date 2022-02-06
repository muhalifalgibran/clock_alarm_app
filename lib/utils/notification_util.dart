import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationUtil {
  static final _instance = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  // show scheduled notification
  static Future showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
    required DateTime time,
  }) async {
    return _instance.zonedSchedule(
      id ?? 0,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      await _notificationDetail(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // show notification by now
  static Future notifNow({
    int? id,
    String? title,
    String? body,
    String? payload,
    required DateTime time,
  }) async {
    return _instance.show(
      id ?? 0,
      title,
      body,
      await _notificationDetail(),
      payload: payload,
    );
  }

  // set notification settings
  static Future _notificationDetail() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'your other channel description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alarm'),
        enableVibration: true,
      ),
      iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'alarm.wav'),
    );
  }

  // initialize the notification
  static Future init({bool initScheduled = false}) async {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);
    await _instance.initialize(settings, onSelectNotification: (payload) {
      onNotification.add(payload);
    });
  }

  // cancel specific alarm by id
  static Future cancelAlarm(int id) async {
    await _instance.cancel(id);
  }

  // cancel all the alarm
  static Future cancelAllAlarm() async {
    await _instance.cancelAll();
  }
}
