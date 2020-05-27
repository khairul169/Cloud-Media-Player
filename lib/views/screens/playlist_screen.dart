import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playlists.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/presentation/file_dropzone.dart';
import 'package:cmp/views/presentation/playback_panel_wrap.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class PlaylistScreen extends StatefulWidget {
  final int playlistIndex;

  PlaylistScreen({
    Key key,
    this.playlistIndex,
  }) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Future<void> onFilesDropped(List<html.File> files) async {
    for (var file in files) {
      print('Uploading ' + file.name);
      await StoreProvider.dispatchFuture(
        context,
        PlaylistAddItem(widget.playlistIndex, file),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Playlist>(
      converter: (store) {
        return store.state.playlists[widget.playlistIndex];
      },
      builder: (_, playlist) => Scaffold(
        appBar: AppBar(
          title: Text(playlist.title.toUpperCase()),
          centerTitle: true,
        ),
        body: PlaybackPanelWrap(
          child: FileDropZone(
            child: buildMediaList(playlist.items),
            hoverColor: Colors.blue.withOpacity(0.5),
            onDrop: onFilesDropped,
          ),
        ),
      ),
    );
  }

  Widget buildMediaList(List<Media> items) {
    return MediaListView(
      items: items,
      onDelete: (id) {
        StoreProvider.dispatch(
          context,
          PlaylistDeleteItem(widget.playlistIndex, id),
        );
      },
    );
  }
}
