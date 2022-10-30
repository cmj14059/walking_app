import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:walking_app/view_model/health/health_notifier.dart';
import 'step_circle_progress.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}
class HomePageState extends ConsumerState<HomePage> {

  late Future<void> futureInit;  //FutureBuilderで待つ初期化処理

  @override
  void initState() {
    super.initState();

    //起動時歩数を更新して表示
    final state = ref.read(healthNotifierProvider);
    final stateProvider = ref.read(healthNotifierProvider.notifier);
    futureInit = stateProvider.updateData();

    print(ref.read(healthNotifierProvider.notifier).state.appState);
  }

////build
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final healthState = ref.watch(healthNotifierProvider);
    final healthStateNotifier = ref.watch(healthNotifierProvider.notifier);

    healthStateNotifier.updateData;

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
          actions: <Widget>[
            const SizedBox(
              height: 60,
              width: 5,
            ),
            ElevatedButton.icon(
              onPressed: healthStateNotifier.updateData,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120,60),
                primary: Colors.purple.withOpacity(0.3),
                onPrimary: Colors.grey,
              ),
              icon: const Icon(
                Icons.shop,
                color: Colors.black,
              ),
              label: const Text(
                "交換所",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () {
                print(healthStateNotifier.state.appState);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(110,60),
                primary: Colors.grey,
                onPrimary: Colors.grey,
              ),
              icon: const Icon(
                Icons.money,
                color: Colors.black,
              ),
              label: Text(
                "${healthStateNotifier.getAllStep() / 1000} gem",
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black
                ),
              ),
            ),
            const SizedBox(
              height: 60,
              width: 5,
            ),
            // IconButton(
            //   icon: const Icon(
            //       Icons.file_download,
            //     color: Colors.black,
            //   ),
            //   onPressed: updateData,
            // ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            //PlayVideo(),
            Row(
              children: [
                const SizedBox(
                  height: 120,
                  width: 5,
                ),
                ElevatedButton.icon(
                  onPressed: healthStateNotifier.updateData,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(120,70),
                    primary: Colors.purple,
                    onPrimary: Colors.grey,
                  ),
                  icon: const Icon(
                    Icons.shop,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "交換所",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(110,60),
                    primary: Colors.grey,
                    onPrimary: Colors.grey,
                  ),
                  icon: const Icon(
                    Icons.money,
                    color: Colors.black,
                  ),
                  label: Text(
                    "${healthStateNotifier.getAllStep() / 100} gem",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),
                  ),
                ),
                const SizedBox(
                  height: 120,
                  width: 5,
                ),
              ],
            ),

            FutureBuilder(
              future: futureInit,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // if(snapshot.hasData)
                //   return showCircleProgress(ref);
                // else return healthStateNotifier.content();
                return showCircleProgress(ref);
              },
            ),

            Container(
              height: screenSize.height*0.05,
            ),

            SizedBox(
              height: screenSize.height*0.3,
              width: screenSize.width*0.9,
              child: LineChart(
                // 折線グラフ
                LineChartData(
                  // 折れ線グラフデータ
                    maxX: 6,
                    minX: 0,
                    minY: 0,
                    backgroundColor: Colors.blueGrey,
                    borderData: FlBorderData(
                      border: Border(
                          top: BorderSide(
                            color: Colors.red,
                            width: 10,
                          )
                      ),
                    ),
                    lineTouchData: LineTouchData(

                    ),

                    lineBarsData: [
                      // 線を表示するためのデータ
                      LineChartBarData(
                          isCurved: false,
                          barWidth: 5.0, // 線の幅
                          color: Colors.orange, // 線の色
                          spots: [
                            FlSpot(0, 5000), // 左が横で、右が高さの数値
                            FlSpot(1, 1222),
                            FlSpot(2, 1440),
                            FlSpot(3, 8011),
                            FlSpot(4, 9000),
                            FlSpot(5, 6000),
                            FlSpot(6, 4000),
                          ])
                    ]),
                swapAnimationDuration: Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              ),
            ),

            Container(
              height: screenSize.height*0.05,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                print("pushed Gradient Button");
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.red,
                      Colors.blue,
                      Colors.orange,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(100),
                child: const Text('Gradient Button'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
