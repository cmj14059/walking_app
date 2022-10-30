import 'package:health/health.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walking_app/model/health/health_state.dart';


final healthNotifierProvider = StateNotifierProvider((ref) => HealthNotifier());


class HealthNotifier extends StateNotifier<HealthState> {
  HealthNotifier(): super(HealthState());

  List<HealthDataPoint> _healthDataList = [];

  Future fetchData() async {
    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      // HealthDataType.WEIGHT,
      // HealthDataType.HEIGHT,
      // HealthDataType.BLOOD_GLUCOSE,
      // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    state = HealthState(appState: AppState.FETCHING_DATA);

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
        if (!isManualData(x)) {
          print("Data point: $x");
          steps += x.value.hashCode;
        }
      }

      print("Steps: $steps");

      /// Update the UI to display the results
      state = HealthState(
          appState: _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY
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
    else if (state.appState == AppState.NO_DATA) {
      return _contentNoData();
    }
    else if (state.appState == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (state.appState == AppState.AUTH_NOT_GRANTED)
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
    print(state.appState);
  }

}