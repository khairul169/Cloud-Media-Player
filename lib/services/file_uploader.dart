import 'dart:async';
import 'dart:io';
import 'package:cmp/models/api_result.dart';
import 'package:cmp/public/utils.dart';
import 'package:http/http.dart';
import 'package:universal_html/html.dart' as html;

class FileUploader extends MultipartRequest {
  final Function(int bytes, int totalBytes) onProgress;
  final Function(APIResult) onComplete;

  FileUploader(Uri uri, {this.onProgress, this.onComplete})
      : super('POST', uri);

  @override
  ByteStream finalize() {
    var stream = super.finalize();
    if (onProgress == null && onComplete == null) {
      return stream;
    }

    final totalBytes = this.contentLength;
    int bytes = 0;

    final handler = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        sink.add(data);
        bytes += data.length;
        if (onProgress != null) {
          onProgress(bytes, totalBytes);
        }
      },
      handleDone: (sink) {
        sink.close();
        if (onComplete != null) {
          onComplete(null);
        }
      },
    );

    return ByteStream(stream.transform(handler));
  }

  Future<void> addFile(String key, File file) async {
    var path = file.path;
    var multipart = await MultipartFile.fromPath(key, path);
    this.files.add(multipart);
  }

  Future<void> addFileHtml(String key, html.File file) async {
    var bytes = await Utils.htmlFileToBytes(file);
    var multipart = MultipartFile.fromBytes(key, bytes, filename: file.name);
    this.files.add(multipart);
  }
}
