import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';


class HoomePage extends StatefulWidget {
  const HoomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HoomePage> createState() => _MyHomePageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _MyHomePageState extends State<HoomePage> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    //起動時歩数を更新して表示
    updateData;
    showCircleProgress();
  }

  Future fetchData() async {
    /// Get everything from midnight until now
    final now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      // HealthDataType.WEIGHT,
      // HealthDataType.HEIGHT,
      // HealthDataType.BLOOD_GLUCOSE,
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    setState(() => _state = AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startDate, endDate, types);

        /// Save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      /// Print the results
      for (var x in _healthDataList) {
        if(!isManualData(x)) {
          print("Data point: $x");
          steps += x.value.hashCode;
        }
      }

      print("Steps: $steps");

      /// Update the UI to display the results
      setState(() {
        _state =
        _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              strokeWidth: 10,
            )
        ),
        const Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return Text(
      "${getAllStep()}",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 75,
      ),
    );

  }

  Widget _contentNoData() {
    return const Text(
      '0',
      style: TextStyle(
        color: Colors.black,
        fontSize: 75,
      ),
    );
  }

  Widget _contentNotFetched() {
    return const Text('Press the download button to fetch data');
  }

  Widget _authorizationNotGranted() {
    return const Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();

    return _contentNotFetched();
  }

  //歩数が手動入力かどうか判定
  bool isManualData(HealthDataPoint p) {
    if(p.sourceId == "com.apple.Health") {
      return true;
    } else {
      return false;
    }
  }

  //歩数の合計をnum型で取得
  num getAllStep() {
    num pAll = 0;
    for(int i = 0; i < _healthDataList.length; i++) {
      HealthDataPoint p = _healthDataList[i];
      // if(!isManualData(p)) {
      //   pAll += p.value.hashCode;
      // }
      pAll += p.value.hashCode;
    }
    return pAll;
  }

  //データを最新状態に更新
  Future<void> updateData() async {
    await Permission.activityRecognition.request().isGranted;
    await fetchData();
  }

  //歩数のカウントを円で可視化
  Widget showCircleProgress() {
    const double s = 300;
    return Stack(

      children: [
        Align(
          alignment: const Alignment(0,0),
          child: CustomPaint(
            size: const Size(s,s),
            //foregroundPainter: CircleProgress(getAllStep()),
          ),
        ),
        SizedBox(
          height: 4/5*s,
          child: Align(
            alignment: const Alignment(0,0),
            child: _content(),
          ),
        ),
        Column(
          children: const [
            SizedBox(
              height: 3*s/5,
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Text(
                '今日の歩数',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 30
                ),
              ),
            ),
            SizedBox(
              height: s/3,
            )
          ],
        )
      ],
    );
  }

  //歩数の上限を設定


////build
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

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
              onPressed: updateData,
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
                "${getAllStep() / 1000} gem",
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
                  onPressed: updateData,
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
                    "${getAllStep() / 100} gem",
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

            showCircleProgress(),



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



            // const SizedBox(
            //   height: 300,
            //   child: Text(
            //     'make page1, use Stack and Align, BottomNavigationBar',
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     fixedSize: Size(50, 300),
            //     primary: Colors.blue,
            //     onPrimary: Colors.red,
            //   ),
            //   onPressed: () async {
            //     await Permission.activityRecognition.request().isGranted;
            //     await fetchData();
            //   },
            //   child: const Text(
            //       '健康第一',
            //       style: TextStyle(
            //         color: Colors.white,
            //       )
            //   ),
            // ),
            //PlayVideo(),
          ],
        ),
      ),
    );
  }
}
