import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class WheelClock extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double cx = size.width / 2;
    double cy = size.height / 2;
    var center = Offset(cx, cy);
    double radius = 150;
    double radiusCenter = 10;

    var clockCircle = Paint()..color = Colors.grey.shade800;

    canvas.drawCircle(center, radius - 6, clockCircle);

    final paint = Paint();
    final paintCenter = Paint();

    for (int i = 0; i < 60; i++) {
      double minute = 360 / 60 * i;

      paint.color = (i % 5 == 0) ? Colors.white60 : Colors.grey;
      paint.strokeWidth = (i % 5 == 0) ? 4 : 1;

      // distance from center to the edge
      double distance = (i % 5 == 0) ? 40 : 20;

      // define the position of the line
      // y takes sin because it vertical, x vice versa
      double x1 = radius * cos(vector.radians(minute));
      double y1 = radius * sin(vector.radians(minute));
      final p1 = Offset(x1, y1);

      double x2 = (radius - distance) * cos(vector.radians(minute));
      double y2 = (radius - distance) * sin(vector.radians(minute));
      final p2 = Offset(x2, y2);

      // if (i == 59) {
      //   print(x1);
      //   print(y1);
      //   print(x2);
      //   print(y2);
      //   canvas.drawCircle(Offset(x1, y1), radiusCenter, paintCenter);
      //   canvas.drawCircle(Offset(x2, y2), radiusCenter, paintCenter);
      // }

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
