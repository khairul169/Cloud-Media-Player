import 'package:async_redux/async_redux.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cmp/actions/MediaList.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/screens/Upload.dart';
import 'package:cmp/services/AppState.dart';
import 'package:cmp/services/PlayerService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    PlayerService.setRepeatMode(PlayerRepeat.All);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    StoreProvider.dispatch<AppState>(context, FetchMediaList());
  }

  void onStartMedia(int id) {
    // Play media
    var state = StoreProvider.state<AppState>(context);
    if (state.mediaList.items == null) return;

    var playList = Playlist.fromMediaList(state.mediaList);
    PlayerService.setPlayList(playList, playId: id);
  }

  void onAddPress() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UploadScreen(),
    ));
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

  StreamBuilder<MediaItem> buildPlaybackPanel() {
    return StreamBuilder<MediaItem>(
      stream: AudioService.currentMediaItemStream,
      builder: (context, media) => StreamBuilder<PlaybackState>(
        stream: AudioService.playbackStateStream,
        builder: (context, event) {
          var title = media.data?.title ?? '-';
          var duration = media.data?.duration ?? 0;
          var position = event.data?.position ?? 0;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Title: $title'),
                  Text('Position: $position'),
                  Text('Duration: $duration'),
                ]),
          );
        },
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
          buildPlaybackPanel(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddPress,
      ),
    );
  }
}
