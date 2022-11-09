import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'CircleProgress.dart';
import 'PlayVideo.dart';
import 'EmptyAppBar.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text(
            'Bit Walk',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[],
        )
      ),

      body: Container(
        height: 500,
        width: 300,
        child: LineChart(
          // 折線グラフ
          LineChartData(
            // 折れ線グラフデータ
            // read about it in the LineChartData section
              maxX: 8, // x 軸の最大 x を取得します。null の場合、値は入力 lineBars から読み取られます
              maxY: 8, // y 軸の最大 y を取得します。null の場合、値は入力 lineBars から読み取られます
              minX: 0, // x 軸の最小 x を取得します。null の場合、値は入力 lineBars から読み取られます
              minY: 0, // y 軸の最小 y を取得します。null の場合、値は入力 lineBars から読み取られます

              lineBarsData: [
                // 線を表示するためのデータ
                LineChartBarData(
                  // この中に線の色やサイズを書く!
                    isCurved: false,
                    barWidth: 3.0, // 線の幅
                    color: Colors.green[300], // 線の色
                    spots: [
                      FlSpot(0, 5), // 左が横で、右が高さの数値
                      FlSpot(1, 2),
                      FlSpot(2, 8),
                      FlSpot(3, 4),
                      FlSpot(4, 2),
                      FlSpot(5, 6),
                      FlSpot(6, 0),
                      FlSpot(7, 8),
                      FlSpot(8, 5),
                    ])
              ]),
          swapAnimationDuration: Duration(milliseconds: 150),
          swapAnimationCurve: Curves.linear,
        ),
      ),
    );
  }
}