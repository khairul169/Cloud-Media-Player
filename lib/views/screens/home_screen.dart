import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/actions/playlists.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/containers/playback_panel_view.dart';
import 'package:cmp/views/presentation/file_dropzone.dart';
import 'package:cmp/views/presentation/navigation_bar.dart';
import 'package:cmp/views/presentation/playlist_library.dart';
import 'package:cmp/views/presentation/section_title.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onRefresh();
  }

  Future<void> onRefresh() async {
    await StoreProvider.dispatchFuture(context, FetchPlaylists());
  }

  Future<void> onFilesDropped(List<html.File> files) async {
    for (var file in files) {
      print('Uploading ' + file.name);
      await StoreProvider.dispatchFuture(context, PlaylistAddItem(0, file));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: buildContent(context),
              ),
            ),
          ),
          PlaybackPanelView(),
        ],
      ),
    );
  }

  Column buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Browse',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        NavigationBar(
          items: ['Library', 'Popular'],
          onSelect: (id) {},
        ),
        SizedBox(height: 16),
        SectionTitle(
          title: 'Playlist',
          onMore: () {},
        ),
        StoreConnector<AppState, List<Playlist>>(
          converter: (store) => store.state.playlists,
          builder: (_, items) => PlaylistLibrary(
            items: items,
            onPress: (playlist) {
              //Navigator.
            },
            onPlay: (playlist) {
              StoreProvider.dispatch(
                context,
                SetPlaybackList(playlist, playId: 0),
              );
            },
          ),
        ),
        SizedBox(height: 24),
        SectionTitle(
          title: 'Local Media',
          onMore: () {},
        ),
        FileDropZone(
          child: buildMediaList(),
          hoverColor: Colors.blue.withOpacity(0.5),
          onDrop: (files) => onFilesDropped(files),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  StoreConnector<AppState, List<Media>> buildMediaList() {
    return StoreConnector<AppState, List<Media>>(
      converter: (store) {
        var playlists = store.state.playlists;
        if (playlists != null && playlists.length > 0) {
          return playlists[0].items;
        }
        return null;
      },
      builder: (_, mediaList) => MediaListView(
        items: mediaList,
        onDelete: (id) {
          StoreProvider.dispatch(context, PlaylistDeleteItem(0, id));
        },
      ),
    );
  }
}
