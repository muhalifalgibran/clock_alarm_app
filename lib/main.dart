import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:alarm_clock/ui/home_screen.dart';
import 'package:alarm_clock/utils/notification_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() {
  Get.put(ClockController());
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clock Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
