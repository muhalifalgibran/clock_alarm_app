import 'package:alarm_clock/controller/clock_controller.dart';
import 'package:alarm_clock/ui/pages/bar_chart_package.dart';
import 'package:alarm_clock/ui/pages/clock_alarm_page.dart';
import 'package:alarm_clock/ui/pages/list_alarm_page.dart';
import 'package:alarm_clock/utils/notification_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ClockController _dx = Get.find();

  @override
  void initState() {
    super.initState();
    NotificationUtil.init();
    listenNotification();
    // check if there is no alarm in the list than
    // remove all alarms, in case alarms are sets
    // without no item in alarms list
    if (_dx.alarms.isEmpty) {
      _dx.cancelAllAlarm();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // listen the notification behavior
  // in this case is just by tap
  void listenNotification() =>
      NotificationUtil.onNotification.stream.listen((payload) async {
        _dx.removeAlarmById(int.parse(payload ?? ''));
        Get.to(() => BarChartAlarm(id: int.parse(payload ?? '')));
      });

  static const List<Widget> _widgetOptions = <Widget>[
    ClockAlarmPage(),
    ListAlarmPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.alarm_add), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      );
    });
  }
}
