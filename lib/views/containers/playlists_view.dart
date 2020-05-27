import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/presentation/playlist_library.dart';
import 'package:cmp/views/screens/playlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaylistsView extends StatelessWidget {
  final int maxItems;

  const PlaylistsView({Key key, this.maxItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Playlist>>(
      converter: (store) {
        return store.state.playlists;
      },
      builder: (_, items) => PlaylistLibrary(
        items: (maxItems != null && items != null && maxItems <= items.length)
            ? items.sublist(0, maxItems)
            : items,
        onPress: (playlist) {
          var index = items.indexOf(playlist);
          Navigator.of(context).push(CupertinoPageRoute(
            builder: (_) => PlaylistScreen(playlistIndex: index),
          ));
        },
        onPlay: (playlist) {
          // Play media list
          StoreProvider.dispatch(context, SetPlaybackList(playlist, playId: 0));
        },
      ),
    );
  }
}
