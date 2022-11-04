import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../const/color/color.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              title: const Text(
                'Shop Page',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: APP_BAR_COLOR,
              elevation: 0.0,
              actions: <Widget>[],
            )
        ),

        body: Container(
        ),
      ),
    );
  }
}
