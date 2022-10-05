import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'CircleProgress.dart';
import 'EmptyAppBar.dart';

//void main() {
  //runApp(const MyApp());
//}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Walking App 頑張るぞぉ",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'walking_app 頑張るそ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _MyHomePageState extends State<MyHomePage> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;

  @override
  void initState() {
    super.initState();
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
            )),
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
    return const Text('No Data to show');
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

  //歩数のカウントを円で可視化
  Widget getCircleProgress() {
    const double s = 300;
    return Stack(

      children: [
        Align(
          alignment: const Alignment(0,0),
          child: CustomPaint(
            size: const Size(s,s),
            foregroundPainter: CircleProgress(getAllStep()),
          ),
        ),
        SizedBox(
          height: 3/4*s,
          child: Align(
            alignment: const Alignment(0,0),
            child: _content(),
          ),
        ),
        const SizedBox(
          height: 5/4*s,
          child: Align(
            alignment: Alignment(0, 0),
            child: Text(
              '今日の歩数',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 30
              ),
            ),
          ),
        )

      ],
    );
  }

  //歩数の上限を設定

////build
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
            'Bit Walk',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
                Icons.file_download,
              color: Colors.black,
            ),
            onPressed: () async {
              await Permission.activityRecognition.request().isGranted;
              await fetchData();
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  height: 120,
                  width: 5,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Permission.activityRecognition.request().isGranted;
                    await fetchData();
                  },
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

            getCircleProgress(),

            const SizedBox(
              height: 300,
              child: Text('I am Takumi Koide',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),

            const SizedBox(
              height: 300,
              child: Text(
                'make page1, use Stack and Align, BottomNavigationBar',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(50, 300),
                primary: Colors.blue,
                onPrimary: Colors.red,
              ),
              onPressed: () async {
                await Permission.activityRecognition.request().isGranted;
                await fetchData();
              },
              child: const Text(
                  '健康第一',
                  style: TextStyle(
                    color: Colors.white,
                  )
              ),
            ),
        ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            activeIcon: Icon(Icons.book_online),
            label: 'Book',
            tooltip: "This is a Book Page",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            activeIcon: Icon(Icons.business_center),
            label: 'Business',
            tooltip: "This is a Business Page",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.school_outlined),
            label: 'School',
            tooltip: "This is a School Page",
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
