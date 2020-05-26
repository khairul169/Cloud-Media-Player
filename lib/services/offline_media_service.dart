import 'dart:async';
import 'dart:io';
import 'package:cmp/models/media.dart';
import 'package:cmp/services/database_provider.dart';
import 'package:cmp/services/download_service.dart';
import 'package:flutter/foundation.dart';

class OfflineMediaService {
  /// Download media to local storage
  static Future<Media> download(Media media) async {
    if (media.local) {
      return media;
    }

    var res = await DownloadService.download(media.url);
    var completer = Completer<Media>();

    res.stream.listen(null, onDone: () {
      setLocalPath(media.id, res.path).then((_) {
        completer.complete(media.copyWith(localPath: res.path));
      });
    });

    return completer.future;
  }

  /// Remove media from local storage
  static Future<Media> remove(Media media) async {
    if (!media.local) {
      return media;
    }

    // Delete local file
    await File(media.localPath).delete();
    await removeLocal(media.id);

    return media.copyWith(localPath: 'null');
  }

  /// Get media stored local path
  static Future<String> getLocalPath(int id) async {
    var path = await DBProvider.getById(DBProvider.storeItems, id);
    return path != null ? path as String : null;
  }

  /// Set media local path
  static Future<void> setLocalPath(int id, String path) async {
    await DBProvider.save(DBProvider.storeItems, path, id: id);
  }

  /// Remove local media path data
  static Future<void> removeLocal(int id) async {
    await DBProvider.remove(DBProvider.storeItems, id);
  }

  /// Check media offline availability
  static Future<Media> check(Media media) async {
    if (kIsWeb) {
      return media;
    }

    var localPath = await OfflineMediaService.getLocalPath(media.id);
    return media.copyWith(localPath: localPath ?? 'null');
  }

  /// Check list of media offline availability
  static Future<List<Media>> checkAll(List<Media> mediaList) async {
    if (kIsWeb) {
      return mediaList;
    }

    for (Media media in mediaList) {
      var idx = mediaList.indexOf(media);
      mediaList[idx] = await check(media);
    }
    return mediaList;
  }
}
