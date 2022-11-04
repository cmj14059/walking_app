import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:walking_app/view_model/home_page/health/health_notifier.dart';

import '../../model/health/health_state.dart';

class StepBarChart extends ConsumerStatefulWidget {
  const StepBarChart({Key? key}) : super(key: key);

  @override
  StepBarChartState createState() => StepBarChartState();
}

class StepBarChartState extends ConsumerState<StepBarChart> {

  @override
  Widget build(BuildContext context) {
  List<BarChartGroupData> barGroups = getBarGroups();
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 10000,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    
    String text;
    switch (6 - value.toInt()) {
      case 6:
        text = getWeekDay(six.weekday);
        break;
      case 5:
        text = getWeekDay(five.weekday);
        break;
      case 4:
        text = getWeekDay(four.weekday);
        break;
      case 3:
        text = getWeekDay(three.weekday);
        break;
      case 2:
        text = getWeekDay(two.weekday);
        break;
      case 1:
        text = getWeekDay(one.weekday);
        break;
      case 0:
        text = getWeekDay(now.weekday);
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> getBarGroups() {
    final healthState = ref.watch(healthNotifierProvider);
    final healthStateNotifier = ref.watch(healthNotifierProvider.notifier);
    List<num> weekStepList = healthStateNotifier.getWeekStepList();

    List<BarChartGroupData> list = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: weekStepList[6].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: weekStepList[5].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: weekStepList[4].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: weekStepList[3].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: weekStepList[2].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            toY: weekStepList[1].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
            toY: weekStepList[0].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ),
    ];

    return list;
  }

  String getWeekDay(int i) {
    String weekday = '';
    switch(i) {
      case 1:
        weekday = '月';
        break;
      case 2:
        weekday = '火';
        break;
      case 3:
        weekday = '水';
        break;
      case 4:
        weekday = '木';
        break;
      case 5:
        weekday = '金';
        break;
      case 6:
        weekday = '土';
        break;
      case 7:
        weekday = '日';
        break;
    }
    return weekday;
  }
}
