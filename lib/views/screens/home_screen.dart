import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playlists.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/containers/playlists_view.dart';
import 'package:cmp/views/presentation/navigation_bar.dart';
import 'package:cmp/views/presentation/playback_panel_wrap.dart';
import 'package:cmp/views/presentation/section_title.dart';
import 'package:cmp/views/screens/playlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: PlaybackPanelWrap(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: buildContent(context),
          ),
        ),
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
        PlaylistsView(
          maxItems: 3,
        ),
        buildPlaylistsMedia(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildPlaylistsMedia() {
    return StoreConnector<AppState, List<Playlist>>(
      converter: (store) {
        return store.state.playlists;
      },
      builder: (_, lists) {
        if (lists == null) {
          return Container();
        }
        return Wrap(
          children: List.generate(lists.length, (index) {
            var playlist = lists[index];
            return Column(
              children: [
                SizedBox(height: 24),
                SectionTitle(
                  title: playlist.title,
                  onMore: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => PlaylistScreen(playlistIndex: index),
                    ));
                  },
                ),
                MediaListView(
                  items: playlist.items,
                  shrinkWrap: true,
                  maxItems: 5,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
