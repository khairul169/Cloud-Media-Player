import 'dart:async';
import 'dart:io';

import 'package:cmp/models/ApiResult.dart';
import 'package:http/http.dart';

class FileUploadRequest extends MultipartRequest {
  final Function(int bytes, int totalBytes) onProgress;
  final Function(ApiResult) onComplete;

  FileUploadRequest(Uri uri, {this.onProgress, this.onComplete})
      : super('POST', uri);

  @override
  ByteStream finalize() {
    var stream = super.finalize();
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
    var fileMultipart = await MultipartFile.fromPath(key, path);
    this.files.add(fileMultipart);
  }
}
