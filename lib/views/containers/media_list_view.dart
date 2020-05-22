import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/media_list.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/presentation/media_list.dart';
import 'package:flutter/material.dart';

class MediaListView extends StatefulWidget {
  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch media list
    StoreProvider.dispatch(context, FetchMediaList());
  }

  void onStartMedia(int index) {
    // Play media
    var mediaList = StoreProvider.state<AppState>(context).mediaList;
    var playlist = Playlist(items: mediaList);
    StoreProvider.dispatch(context, SetPlaylist(playlist, playId: index));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Media>>(
      converter: (store) => store.state.mediaList,
      builder: (_, mediaList) => mediaList == null
          ? Text('Loading...')
          : MediaList(items: mediaList, onItemPress: onStartMedia),
    );
  }
}
