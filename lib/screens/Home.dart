import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/MediaList.dart';
import 'package:cmp/actions/PlayerState.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/states/AppState.dart';
import 'package:cmp/widgets/PlaybackPanel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch media list
    StoreProvider.dispatch(context, FetchMediaList());
  }

  void onStartMedia(int id) {
    // Play media
    var mediaList = StoreProvider.state<AppState>(context).mediaList;
    var playlist = Playlist.fromMediaList(mediaList);
    StoreProvider.dispatch(context, SetPlaylist(playlist, playId: id));
  }

  Widget buildMediaList(MediaList mediaList) {
    if (mediaList.items == null) return Container();
    return ListView.builder(
      itemCount: mediaList.items.length,
      itemBuilder: (_, index) {
        var item = mediaList.items[index];
        return buildMediaItem(index, item);
      },
    );
  }

  Widget buildMediaItem(int index, Media item) {
    return Card(
      child: InkWell(
        onTap: () => onStartMedia(index),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title),
                    Text(item.artist),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Media Player'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: StoreConnector<AppState, MediaList>(
              converter: (store) => store.state.mediaList,
              builder: (_, mediaList) => mediaList == null
                  ? Text('Loading...')
                  : buildMediaList(mediaList),
            ),
          ),
          PlaybackPanel(),
        ],
      ),
    );
  }
}
