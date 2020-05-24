import 'dart:convert';
import 'dart:math';

///
/// Utils
///

class Utils {
  static final _randomizer = Random.secure();

  static bool isEmpty(String s) => s == null || s.isEmpty;

  static String timeToString(int time) {
    if (time == null || time <= 0) return '0:00';

    var m = (time ~/ 60);
    var s = (time - (m * 60)).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static String randString([int length = 12]) {
    final bytes = List<int>.generate(
      length + 16,
      (index) => _randomizer.nextInt(256),
    );
    return base64Encode(bytes)
        .replaceAll(new RegExp(r'/'), '')
        .substring(0, length);
  }
}
