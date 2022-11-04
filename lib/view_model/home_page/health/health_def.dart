final now = DateTime.now();
DateTime STARTDAY = DateTime(now.year, now.month, now.day, 0, 0, 0);
DateTime ENDDAY = DateTime(now.year, now.month, now.day, 23, 59, 59);

var WEEK = [
  [
    DateTime(now.subtract(const Duration(days: 1)).year, now.subtract(const Duration(days: 1)).month, now.subtract(const Duration(days: 1)).day, 0, 0, 0),
    DateTime(now.subtract(const Duration(days: 2)).year, now.subtract(const Duration(days: 2)).month, now.subtract(const Duration(days: 2)).day, 0, 0, 0),
    DateTime(now.subtract(const Duration(days: 3)).year, now.subtract(const Duration(days: 3)).month, now.subtract(const Duration(days: 3)).day, 0, 0, 0),
    DateTime(now.subtract(const Duration(days: 4)).year, now.subtract(const Duration(days: 4)).month, now.subtract(const Duration(days: 4)).day, 0, 0, 0),
    DateTime(now.subtract(const Duration(days: 5)).year, now.subtract(const Duration(days: 5)).month, now.subtract(const Duration(days: 5)).day, 0, 0, 0),
    DateTime(now.subtract(const Duration(days: 6)).year, now.subtract(const Duration(days: 6)).month, now.subtract(const Duration(days: 6)).day, 0, 0, 0),
  ],
  [
    DateTime(now.subtract(const Duration(days: 1)).year, now.subtract(const Duration(days: 1)).month, now.subtract(const Duration(days: 1)).day, 23, 59, 59),
    DateTime(now.subtract(const Duration(days: 2)).year, now.subtract(const Duration(days: 2)).month, now.subtract(const Duration(days: 2)).day, 23, 59, 59),
    DateTime(now.subtract(const Duration(days: 3)).year, now.subtract(const Duration(days: 3)).month, now.subtract(const Duration(days: 3)).day, 23, 59, 59),
    DateTime(now.subtract(const Duration(days: 4)).year, now.subtract(const Duration(days: 4)).month, now.subtract(const Duration(days: 4)).day, 23, 59, 59),
    DateTime(now.subtract(const Duration(days: 5)).year, now.subtract(const Duration(days: 5)).month, now.subtract(const Duration(days: 5)).day, 23, 59, 59),
    DateTime(now.subtract(const Duration(days: 6)).year, now.subtract(const Duration(days: 6)).month, now.subtract(const Duration(days: 6)).day, 23, 59, 59),
  ],
];