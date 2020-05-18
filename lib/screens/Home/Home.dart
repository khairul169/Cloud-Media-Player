import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/MediaDetail.dart';
import 'package:cmp/services/ApiHelper.dart';
import 'package:cmp/services/AudioPlayerTask.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String test;
  List<MediaDetail> mediaList;

  @override
  void initState() {
    super.initState();
    fetchData();
    AudioPlayerTask.startService();
    AudioService.customEventStream.listen((data) {
      print(data);
    });
  }

  void fetchData() async {
    var result = await ApiHelper.get('media/');
    if (result.isError) {
      print(result.message);
      return;
    }

    var itemList = List.from(result.data)
        .map((item) => MediaDetail.fromJson(item))
        .toList();

    setState(() {
      mediaList = itemList;
    });
  }

  void onStartMedia(MediaDetail media) {
    AudioService.playMediaItem(media.toMediaItem());
  }

  void onPlay() {
    AudioService.play();
  }

  void onStop() {
    AudioService.pause();
  }

  Widget buildMediaList() {
    return ListView.builder(
      itemCount: mediaList.length,
      itemBuilder: buildMediaItem,
    );
  }

  Widget buildMediaItem(_, index) {
    var media = mediaList[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 200,
            child: Image.network(
              media.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title: ' + media.title),
              Text('Artist: ' + media.artist),
              Text('Album: ' + media.album),
              Text('Year: ' + media.year.toString()),
              SizedBox(height: 16),
              RaisedButton(
                color: Colors.blue,
                child: Text('Play', style: TextStyle(color: Colors.white)),
                onPressed: () => onStartMedia(media),
              ),
              RaisedButton(
                child: Text('Stop'),
                onPressed: onStop,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Media Player'),
      ),
      body: mediaList != null ? buildMediaList() : Text('Loading...'),
    );
  }
}
