class Alarm {
  int id;
  int hour;
  int minute;
  bool isAm;
  bool isActive;
  DateTime dateTime;

  Alarm(
      {required this.hour,
      required this.id,
      required this.minute,
      required this.dateTime,
      required this.isAm,
      required this.isActive});
}
