import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walking_app/const/color/color.dart';

import '../../view_model/home_page/health/health_notifier.dart';

class CircleProgress extends CustomPainter {
  num currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    //歩いてない分
    Paint outerCircle = Paint()
      ..strokeWidth = 31
      ..color = Colors.white60.withOpacity(0.2)
      ..style = PaintingStyle.stroke;
    //歩いた分
    Paint completeArc = Paint()
      ..strokeWidth = 30
      ..color = CIRCLE_PROGESS_COLOR
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

//歩数のカウントを円で可視化
Widget showCircleProgress(WidgetRef ref) {
  final healthStateNotifier = ref.watch(healthNotifierProvider.notifier);
  const double size = 300;  //円のサイズ

  return Stack(

    children: [
      Align(
        alignment: const Alignment(0, 0),
        child: CustomPaint(
          size: const Size(size, size),
          foregroundPainter: CircleProgress(healthStateNotifier.getAllStep()),
        ),
      ),
      SizedBox(
        height: 4 / 5 * size,
        child: Align(
          alignment: const Alignment(0, 0),
          child: healthStateNotifier.content(),
        ),
      ),
      Column(
        children: const [
          SizedBox(
            height: 3 * size / 5,
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Text(
              '今日の歩数',
              style: TextStyle(
                color: WHITE,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: size / 3,
          )
        ],
      )
    ],
  );
}