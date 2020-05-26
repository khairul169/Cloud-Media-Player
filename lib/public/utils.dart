import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

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

  static Future<Uint8List> htmlFileToBytes(html.File file) {
    var reader = html.FileReader();
    var completer = Completer<Uint8List>();

    reader.onLoadEnd.listen((event) {
      Uint8List bytes = reader.result;
      completer.complete(bytes);
    });

    reader.onError.listen((event) {
      completer.completeError(event);
    });

    reader.readAsArrayBuffer(file);
    return completer.future;
  }
}
