import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/screens/Upload.dart';
import 'package:cmp/services/ApiHelper.dart';
import 'package:cmp/services/AudioPlayerTask.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String test;
  Playlist mediaList;
  ScaffoldState scaffold;

  @override
  void initState() {
    super.initState();
    fetchData();
    setRepeatMode(AudioPlayerRepeat.All);
  }

  void fetchData() async {
    var result = await ApiHelper.get('media');
    if (result.isError) {
      scaffold.showSnackBar(SnackBar(content: Text(result.message)));
      return;
    }

    try {
      var itemList = Playlist.fromJson(result.data);
      setState(() {
        mediaList = itemList;
      });
    } catch (error) {
      scaffold.showSnackBar(SnackBar(content: Text('Failed parsing data.')));
    }
  }

  void onStartMedia(int id) {
    var test = Media(
      url: 'http://192.168.43.48:3000/get/u5v7_Hzuz7Q',
      image: 'http://i.ytimg.com/vi/u5v7_Hzuz7Q/hqdefault.jpg',
    );

    AudioService.playMediaItem(test.toMediaItem());
    return;

    // Play media
    var queue = mediaList.toQueue();
    AudioService.replaceQueue(queue);
    AudioService.playFromMediaId(id.toString());
  }

  void onPlay() {
    AudioService.play();
  }

  void onStop() {
    AudioService.pause();
  }

  void setRepeatMode(AudioPlayerRepeat mode) {
    AudioService.customAction('setRepeatMode', mode.index);
  }

  void onAddPress() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UploadScreen(),
    ));
  }

  Widget buildMediaList() {
    return ListView.builder(
      itemCount: mediaList.items.length,
      itemBuilder: buildMediaItem,
    );
  }

  Widget buildMediaItem(_, index) {
    var media = mediaList.items[index];
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
                    media.image,
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
                    Text(media.title),
                    Text(media.artist),
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
      body: Builder(builder: (context) {
        scaffold = Scaffold.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: mediaList != null ? buildMediaList() : Text('Loading...'),
            ),
            buildPlaybackPanel(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddPress,
      ),
    );
  }
}
