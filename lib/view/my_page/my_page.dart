import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:walking_app/view/EmptyAppBar.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EmptyAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withOpacity(0.6),
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'leading',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white.withOpacity(0.6),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Text(
                    'actions',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
            expandedHeight: 50 + kToolbarHeight,
            backgroundColor: Colors.blueGrey,
            pinned: true,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'title',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              titlePadding: const EdgeInsets.all(8),
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              background: Container(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    //PlayVideo(),
                    Row(
                      children: [
                        const SizedBox(
                          height: 120,
                          width: 5,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
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

                        // ElevatedButton.icon(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     fixedSize: const Size(110,60),
                        //     primary: Colors.grey,
                        //     onPrimary: Colors.grey,
                        //   ),
                        //   icon: const Icon(
                        //     Icons.money,
                        //     color: Colors.black,
                        //   ),
                        //   label: Text(
                        //     "${healthStateNotifier.getAllStep() / 100} gem",
                        //     style: TextStyle(
                        //         fontSize: 20,
                        //         color: Colors.black
                        //     ),
                        //   ),
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 50),
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shape: const CircleBorder(
                              side: BorderSide(
                                color: Colors.black,
                                width: 0.4,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            '拓',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 120,
                          width: 5,
                        ),
                      ],
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
                              border: const Border(
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
              ]
            )
          )
        ],
      ),
    );
  }
}
