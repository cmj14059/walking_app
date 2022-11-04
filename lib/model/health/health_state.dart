enum AppState {
DATA_NOT_FETCHED,
FETCHING_DATA,
DATA_READY,
NO_DATA,
AUTH_NOT_GRANTED
}

final now = DateTime.now();
DateTime startNow = DateTime(now.year, now.month, now.day, 0, 0, 0);
DateTime endNow = DateTime(now.year, now.month, now.day, 23, 59, 59);
final one = now.subtract(const Duration(days: 1));
DateTime startOne = DateTime(one.year, one.month, one.day, 0, 0, 0);
DateTime endOne = DateTime(one.year, one.month, one.day, 23, 59, 59);
final two = now.subtract(const Duration(days: 2));
DateTime startTwo = DateTime(two.year, two.month, two.day, 0, 0, 0);
DateTime endTwo = DateTime(two.year, two.month, two.day, 23, 59, 59);
final three = now.subtract(const Duration(days: 3));
DateTime startThree = DateTime(three.year, three.month, three.day, 0, 0, 0);
DateTime endThree = DateTime(three.year, three.month, three.day, 23, 59, 59);
final four = now.subtract(const Duration(days: 4));
DateTime startFour = DateTime(four.year, four.month, four.day, 0, 0, 0);
DateTime endFour = DateTime(four.year, four.month, four.day, 23, 59, 59);
final five = now.subtract(const Duration(days: 5));
DateTime startFive = DateTime(five.year, five.month, five.day, 0, 0, 0);
DateTime endFive = DateTime(five.year, five.month, five.day, 23, 59, 59);
final six = now.subtract(const Duration(days: 6));
DateTime startSix = DateTime(six.year, six.month, six.day, 0, 0, 0);
DateTime endSix = DateTime(six.year, six.month, six.day, 23, 59, 59);

class HealthState {
  AppState appState;

  HealthState({this.appState=AppState.DATA_NOT_FETCHED});

  AppState getState() {
    return appState;
  }
}