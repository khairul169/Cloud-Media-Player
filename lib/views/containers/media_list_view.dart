import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/views/presentation/media_list.dart';
import 'package:flutter/material.dart';

class MediaListView extends StatelessWidget {
  final List<Media> items;

  MediaListView({this.items});

  void onStartMedia(BuildContext context, int index) {
    // Play media
    var playlist = Playlist(items: items);
    StoreProvider.dispatch(context, SetPlaylist(playlist, playId: index));
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return Container();
    }
    return MediaList(
      items: items,
      onItemPress: (id) => onStartMedia(context, id),
    );
  }
}
