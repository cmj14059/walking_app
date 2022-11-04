import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:walking_app/view/EmptyAppBar.dart';

import '../../const/color/color.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            APP_BAR_COLOR,
            BOTTOM_BAR_COLOR,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //appBar: const EmptyAppBar(),
        body: Container(),
      ),
    );
  }
}
