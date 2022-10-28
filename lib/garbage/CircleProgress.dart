import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends CustomPainter {
  num currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 31
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke;
    Paint completeArc = Paint()
      ..strokeWidth = 30
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 7;

    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (currentProgress / 10000);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), -pi / 2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}