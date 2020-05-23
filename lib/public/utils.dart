///
/// Utils
///

class Utils {
  static bool isEmpty(String s) => s == null || s.isEmpty;

  static String timeToString(int time) {
    if (time == null || time <= 0) return '0:00';

    var m = (time ~/ 60);
    var s = (time - (m * 60)).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
