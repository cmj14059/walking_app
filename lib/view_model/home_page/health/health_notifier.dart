import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walking_app/const/steps/walk_steps.dart';
import 'package:walking_app/model/health/health_state.dart';


final healthNotifierProvider = StateNotifierProvider((ref) => HealthNotifier());


class HealthNotifier extends StateNotifier<HealthState> {
  HealthNotifier(): super(HealthState());

  List<HealthDataPoint> nowList = [];
  List<HealthDataPoint> oneList = [];
  List<HealthDataPoint> twoList = [];
  List<HealthDataPoint> threeList = [];
  List<HealthDataPoint> fourList = [];
  List<HealthDataPoint> fiveList = [];
  List<HealthDataPoint> sixList = [];
  List<List<HealthDataPoint>> weekList = [];

  Future fetchData() async {
    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      // HealthDataType.WEIGHT,
      // HealthDataType.HEIGHT,
      // HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    state = HealthState(appState: AppState.FETCHING_DATA);

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    int steps = 0;

    if (accessWasGranted) {
      try {
        /// 今日の歩数所得
        List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(startNow, endNow, types);
        nowList.addAll(healthData);
        oneList.addAll(await health.getHealthDataFromTypes(startOne, endOne, types));
        twoList.addAll(await health.getHealthDataFromTypes(startTwo, endTwo, types));
        threeList.addAll(await health.getHealthDataFromTypes(startThree, endThree, types));
        fourList.addAll(await health.getHealthDataFromTypes(startFour, endFour, types));
        fiveList.addAll(await health.getHealthDataFromTypes(startFive, endFive, types));
        sixList.addAll(await health.getHealthDataFromTypes(startSix, endSix, types));
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      weekList.add(nowList);
      weekList.add(oneList);
      weekList.add(twoList);
      weekList.add(threeList);
      weekList.add(fourList);
      weekList.add(fiveList);
      weekList.add(sixList);

      /// Filter out duplicates
      nowList = HealthFactory.removeDuplicates(nowList);
      oneList = HealthFactory.removeDuplicates(oneList);
      twoList = HealthFactory.removeDuplicates(twoList);
      threeList = HealthFactory.removeDuplicates(threeList);
      fourList = HealthFactory.removeDuplicates(fourList);
      fiveList = HealthFactory.removeDuplicates(fiveList);
      sixList = HealthFactory.removeDuplicates(sixList);

      // /// Print the results
      // for (var x in _healthWeekDataList) {
      //   if (!isManualData(x[0])) {
      //     //print("Data point: $x");
      //     steps += x[0].value.hashCode;
      //   }
      // }

      //print("Steps: $steps");

      /// Update the UI to display the results
      state = HealthState(
          appState: nowList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY
      );
    } else {
      print("Authorization not granted");
      state = HealthState(appState: AppState.DATA_NOT_FETCHED);
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
              color: Colors.blueGrey,
            )
        ),
        // const Text('loading...')
      ],
    );
  }

  Widget _contentDataReady() {
    return Text(
      "${getAllStep()}",
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
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

  Widget content() {
    if (state.appState == AppState.DATA_READY)
      return _contentDataReady();
    else if (state.appState == AppState.NO_DATA)
      return _contentNoData();
    else if (state.appState == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (state.appState == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();

    return _contentNotFetched();
  }


  /// 歩数が手動入力かどうか判定
  bool isManualData(HealthDataPoint p) {
    // if(p.sourceId == "com.apple.Health") {
    //   return true;
    // } else {
    //   return false;
    // }
    return false;
  }

  /// 全体のリストから歩数のみをリストで取得
  List<HealthDataPoint> takeOutStep(List<HealthDataPoint> list) {
    List<HealthDataPoint> stepsList = [];
    for(var x in list) {
      if(x.type == HealthDataType.STEPS) stepsList.add(x);
    }
    return stepsList;
  }

  /// 全体のリストから距離のみを取り出してリストで取得
  List<HealthDataPoint> takeOutDistance(List<HealthDataPoint> list) {
    List<HealthDataPoint> distanceList = [];
    for(var x in list) {
      if(x.type == HealthDataType.DISTANCE_WALKING_RUNNING) distanceList.add(x);
    }
    return distanceList;
  }

  /// 今日の歩数の合計をnum型で取得
  num getAllStep() {
    num pAll = 0;
    for(var x in takeOutStep(nowList)) {
      if(!isManualData(x)) {
        String xString = x.value.toString();
        pAll += double.parse(xString);
      }
    }
    return pAll.toInt();
  }
  /// 指定したリストの歩数合計を取得
  num getTheAllStep(List<HealthDataPoint> list) {
    num pAll = 0;
    for(var x in takeOutStep(list)) {
      if(!isManualData(x)) {
        String xString = x.value.toString();
        pAll += double.parse(xString);
      }
    }
    return pAll.toInt();
  }

  /// 今日の走行距離の合計をnum型で取得
  num getAllDistance() {
    num pAll = 0;
    for(var x in takeOutDistance(nowList)) {
      if(!isManualData(x)) {
        String xString = x.value.toString();
        pAll += meterToKiloMeter(double.parse(xString));
      }
    }
    return double.parse(pAll.toStringAsFixed(DISTANCE_SIG_FIG));
  }
  /// 指定したリストの走行距離合計を取得
  num getTheAllDistance(List<HealthDataPoint> list) {
     num pAll = 0;
    for(var x in takeOutDistance(list)) {
      if(!isManualData(x)) {
        String xString = x.value.toString();
        pAll += meterToKiloMeter(double.parse(xString));
      }
    }
    return double.parse(pAll.toStringAsFixed(DISTANCE_SIG_FIG));
  }

  /// 一週間の歩数のリストを取得
  List<num> getWeekStepList() {
    List<num> weekStepList = [];
    weekStepList.add(getTheAllStep(nowList));
    weekStepList.add(getTheAllStep(oneList));
    weekStepList.add(getTheAllStep(twoList));
    weekStepList.add(getTheAllStep(threeList));
    weekStepList.add(getTheAllStep(fourList));
    weekStepList.add(getTheAllStep(fiveList));
    weekStepList.add(getTheAllStep(sixList));
    return weekStepList;
  }

  /// 一週間の距離のリストを取得
  List<num> getWeekDistanceList() {
    List<num> weekDistanceList = [];
    weekDistanceList.add(getTheAllDistance(nowList));
    weekDistanceList.add(getTheAllDistance(oneList));
    weekDistanceList.add(getTheAllDistance(twoList));
    weekDistanceList.add(getTheAllDistance(threeList));
    weekDistanceList.add(getTheAllDistance(fourList));
    weekDistanceList.add(getTheAllDistance(fiveList));
    weekDistanceList.add(getTheAllDistance(sixList));
    return weekDistanceList;
  }

  /// mをkmに変換
  double meterToKiloMeter(double m) {
    return m / 1000;
  }


  /// データを最新の状態に更新
  Future<void> updateData() async {
    await Permission.activityRecognition.request().isGranted;
    await fetchData();
  }

}