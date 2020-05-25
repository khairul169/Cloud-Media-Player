import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/user_playlist.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/containers/playback_panel_view.dart';
import 'package:cmp/views/presentation/navigation_bar.dart';
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
    await StoreProvider.dispatchFuture(context, FetchUserPlaylist());
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
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('Discover', style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 8),
              NavigationBar(
                items: ['Your library', 'Popular'],
                onSelect: (id) {},
              ),
            ],
          ),
        ),
        StoreConnector<AppState, List<Media>>(
          converter: (store) {
            var playlists = store.state.userPlaylists;
            if (playlists != null && playlists.length > 0) {
              return playlists[0].items;
            }
            return null;
          },
          builder: (_, mediaList) => MediaListView(
            items: mediaList,
            onUpdate: (id) {
              onRefresh();
            },
          ),
        ),
      ],
    );
  }
}
