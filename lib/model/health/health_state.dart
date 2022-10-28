enum AppState {
DATA_NOT_FETCHED,
FETCHING_DATA,
DATA_READY,
NO_DATA,
AUTH_NOT_GRANTED
}

final now = DateTime.now();
DateTime startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

class HealthState {
  AppState appState;

  HealthState({this.appState=AppState.DATA_NOT_FETCHED});

  AppState getState() {
    return appState;
  }
}