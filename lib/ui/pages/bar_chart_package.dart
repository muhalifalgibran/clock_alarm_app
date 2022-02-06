import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:alarm_clock/models/alarm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BarChartAlarm extends StatefulWidget {
  final int id;
  const BarChartAlarm({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BarChartAlarm> createState() => _BarChartAlarmState();
}

class _BarChartAlarmState extends State<BarChartAlarm> {
  final Duration animDuration = const Duration(milliseconds: 250);
  final ClockController _dx = Get.find();
  late Alarm alarm;
  double secondSpan = 0;
  String title = '';

  @override
  void initState() {
    super.initState();
    alarm = _dx.getItem(widget.id).first;
    secondSpan = double.parse(
        (alarm.dateTime.difference(DateTime.now()).inSeconds).abs().toString());
    title = "${alarm.hour}:${alarm.minute}";
    title = DateFormat('kk:mm').format(alarm.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: BarChart(
            barChartData(),
            swapAnimationDuration: animDuration,
          ),
        ),
      ),
    ));
  }

  BarChartData barChartData() {
    return BarChartData(
      barTouchData: BarTouchData(enabled: true),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) =>
              TextStyle(color: Colors.grey.shade900, fontSize: 24),
          margin: 20,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return title;
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTextStyles: (context, value) =>
              TextStyle(color: Colors.grey.shade900, fontSize: 12),
          margin: 0,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      ),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 1 == 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: const Color(0xffe7e8ec),
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(
        show: true,
      ),
      groupsSpace: 0,
      barGroups: getData(),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(x: 0, barsSpace: 0, barRods: [
        BarChartRodData(
            y: 60,
            colors: [Colors.transparent],
            rodStackItems: [
              BarChartRodStackItem(0, secondSpan, Colors.red),
            ],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ])
    ];
  }
}
