import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:cmp/public/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DefaultDownloadTask {
  String id;
  StreamController<DownloadStatus> controller;

  DefaultDownloadTask({this.id, this.controller});
}

class DefaultDownloadService extends BaseDownloadService {
  final recvPort = ReceivePort();

  var _initialized = false;
  var _queue = List<DefaultDownloadTask>();

  Future<void> init() async {
    // Initialize downloader
    await FlutterDownloader.initialize();

    // Register callback
    FlutterDownloader.registerCallback(downloadCallback);

    // Listen for callback message
    recvPort.listen((data) {
      var task = _queue.firstWhere((e) => e.id == data[0]);
      var sink = task.controller;
      var state = DownloadTaskStatus.from(data[1]);
      var downloadState = DownloadState.none;

      if (state == DownloadTaskStatus.running)
        downloadState = DownloadState.running;
      if (state == DownloadTaskStatus.complete)
        downloadState = DownloadState.completed;

      if (downloadState != DownloadState.completed) {
        sink.add(DownloadStatus(
          id: data[0],
          state: downloadState,
          progress: data[2],
        ));
      } else {
        sink.close();
        _queue.remove(task);

        if (_queue.length == 0) {
          IsolateNameServer.removePortNameMapping('download_service');
        }
      }
    });
  }

  @override
  Future<DownloadResult> download(String url, [String filename]) async {
    if (!_initialized) {
      await init();
      _initialized = true;
    }

    final name = filename ?? Utils.randString(16);
    final dir = await getPath();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      fileName: name,
      savedDir: dir,
      showNotification: false,
    );

    if (_queue.length == 0) {
      IsolateNameServer.registerPortWithName(
        recvPort.sendPort,
        'download_service',
      );
    }

    var task = createTask(taskId);
    _queue.add(task);

    return DownloadResult(
      id: taskId,
      filename: name,
      path: dir + '/$name',
      stream: task.controller.stream,
    );
  }

  @override
  Future<String> getPath([String filename]) async {
    var dir = await getApplicationDocumentsDirectory();
    var path = dir.path + (filename != null ? '/$filename' : '');
    return path;
  }

  DefaultDownloadTask createTask(String taskId) {
    return DefaultDownloadTask(id: taskId, controller: StreamController());
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    final port = IsolateNameServer.lookupPortByName('download_service');
    port.send([id, status.value, progress]);
  }
}

class DownloadService {
  static BaseDownloadService _instance;

  static BaseDownloadService get instance {
    if (_instance == null) {
      _instance = !kIsWeb ? DefaultDownloadService() : null;
    }
    return _instance;
  }

  static Future<DownloadResult> download(String url, [String filename]) {
    if (kIsWeb) throw Exception('Web not supported.');
    return instance.download(url, filename);
  }

  static Future<String> getPath(String filename) {
    if (kIsWeb) throw Exception('Web not supported.');
    return instance.getPath(filename);
  }
}

abstract class BaseDownloadService {
  Future<DownloadResult> download(String url, [String filename]);
  Future<String> getPath(String filename);
}

enum DownloadState {
  none,
  running,
  completed,
}

class DownloadStatus {
  final String id;
  final DownloadState state;
  final int progress;

  DownloadStatus({this.id, this.state, this.progress});
}

class DownloadResult {
  final String id;
  final String filename;
  final String path;
  final Stream<DownloadStatus> stream;

  DownloadResult({this.id, this.filename, this.path, this.stream});
}
