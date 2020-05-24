import 'dart:async';
import 'package:cmp/models/media.dart';
import 'package:cmp/services/offline_media_service.dart';
import 'package:flutter/material.dart';

class MediaListBuilder extends StatelessWidget {
  final List<Media> items;
  final Widget Function(List<Media> items) builder;

  MediaListBuilder({final Key key, this.items, this.builder}) : super(key: key);

  final _controller = StreamController();

  Future<Media> checkLocal(Media media) async {
    var index = items.indexOf(media);
    var localPath = await OfflineMediaService.getLocalPath(media.id);
    items[index] = media.withLocalPath(localPath);
    _controller.add(items);
    return media;
  }

  void rebuild([Media media]) async {
    if (media == null) {
      for (var item in items) await checkLocal(item);
    } else {
      checkLocal(media);
    }
  }

  @override
  Widget build(BuildContext context) {
    rebuild();
    return StreamBuilder(
      initialData: items,
      stream: _controller.stream,
      builder: (_, snapshot) {
        return builder(snapshot.data ?? items);
      },
    );
  }
}
