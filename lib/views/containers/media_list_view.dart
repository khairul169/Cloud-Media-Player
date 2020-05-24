import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/offline_media_service.dart';
import 'package:cmp/views/containers/media_list_builder.dart';
import 'package:cmp/views/presentation/media_list.dart';
import 'package:flutter/material.dart';

class MediaListView extends StatelessWidget {
  final List<Media> items;

  MediaListView({this.items});

  final _mediaBuilderKey = GlobalKey();

  void onStartMedia(BuildContext context, int index) {
    // Play media
    var playlist = Playlist(items: items);
    StoreProvider.dispatch(context, SetPlaylist(playlist, playId: index));
  }

  void onDownload(Media media) async {
    if (!media.local) {
      await OfflineMediaService.download(media);
    } else {
      await OfflineMediaService.remove(media);
    }

    // Update media list
    var mediaBuilder = _mediaBuilderKey.currentWidget as MediaListBuilder;
    if (mediaBuilder != null) mediaBuilder.rebuild(media);
  }

  Widget buildMediaList(BuildContext context, List<Media> mediaList) {
    return MediaList(
      items: mediaList,
      onItemPress: (id) => onStartMedia(context, id),
      onItemDownload: (id) => onDownload(items[id]),
      onItemDelete: (id) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return Container();
    }
    return MediaListBuilder(
      key: _mediaBuilderKey,
      items: items,
      builder: (list) => buildMediaList(context, list),
    );
  }
}
