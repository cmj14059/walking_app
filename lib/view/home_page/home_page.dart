import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:walking_app/view/home_page/step_bar_chart.dart';
import 'package:walking_app/view/my_page/my_page.dart';
import 'package:walking_app/view_model/home_page/health/health_notifier.dart';
import '../../const/color/color.dart';
import '../../view_model/page_routing/page_routing_notifier.dart';
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
    final initState = ref.read(healthNotifierProvider);
    final initStateNotifier = ref.read(healthNotifierProvider.notifier);
    futureInit = initStateNotifier.updateData();

  }

////build
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    final pageRoutingState = ref.watch(pageRoutingProvider);
    final pageRoutingStateNotifier = ref.watch(pageRoutingProvider.notifier);

    final healthState = ref.watch(healthNotifierProvider);
    final healthStateNotifier = ref.watch(healthNotifierProvider.notifier);

    healthStateNotifier.updateData;

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
              'Bit Walk',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: APP_BAR_COLOR,
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
                  pageRoutingStateNotifier.goShopPage();
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

        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: APP_BAR_COLOR,
              pinned: true,
              title: Text(
                'walking_app',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 10),
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
                  onPressed: () {
                    pageRoutingStateNotifier.goMyPage();
                  },
                  child: const Text(
                    '拓',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
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
                            onPressed: () {
                              pageRoutingStateNotifier.goMyPage();
                            },
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

                      FutureBuilder(
                        future: futureInit,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          return showCircleProgress(ref);
                        },
                      ),

                      Container(
                        height: screenSize.height*0.05,
                      ),

                      SizedBox(
                        height: screenSize.height*0.3,
                        width: screenSize.width*0.9,
                        child: AspectRatio(
                          aspectRatio: 1.7,
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            color: const Color(0xff2c4260),
                            child: const StepBarChart(),
                          ),
                        )
                      ),
                    ],
                  ),
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}
