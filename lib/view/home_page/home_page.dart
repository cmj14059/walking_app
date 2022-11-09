import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:walking_app/view/home_page/step_bar_chart.dart';
import 'package:walking_app/view/my_page/my_page.dart';
import 'package:walking_app/view_model/home_page/health/health_notifier.dart';
import '../../const/color/color.dart';
import '../../view_model/page_routing/page_routing_notifier.dart';
import 'distance_bar_chart.dart';
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
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          color: Colors.blueGrey,
          backgroundColor: APP_BAR_COLOR,
          edgeOffset: 70,
          onRefresh: () async {
            healthStateNotifier.updateData();
            HapticFeedback.mediumImpact();
          },
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                backgroundColor: APP_BAR_COLOR,
                elevation: 0,
                pinned: false,
                floating: true,
                snap: true,

                title: Text(
                  'walking_app',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        //PlayVideo(),
                        Container(
                          height: 20,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(90, 50),
                                primary: APP_BAR_COLOR,
                                onPrimary: Colors.grey,
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: BLACK,
                                    width: 0.4,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                pageRoutingStateNotifier.goMyPage();
                              },
                              child: Text(
                                '拓',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
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
                        const Text(
                          '＜今週の歩数＞',
                          style: TextStyle(
                            color: WHITE,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
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

                        Container(
                          height: screenSize.height*0.03,
                        ),
                        const Text(
                          '＜今週の歩いた距離(km)＞',
                          style: TextStyle(
                            color: WHITE,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: screenSize.height*0.3,
                          width: screenSize.width*0.9,
                          child: AspectRatio(
                            aspectRatio: 1.7,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              color: Colors.brown,
                              child: const DistanceBarChart(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
