import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmp/models/MediaDetail.dart';
import 'package:cmp/services/ApiHelper.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String test;
  List<MediaDetail> mediaList;
  ScaffoldState scaffold;

  @override
  void initState() {
    super.initState();
    fetchData();
    AudioService.customEventStream.listen((data) {
      print(data);
    });
  }

  void fetchData() async {
    var result = await ApiHelper.get('media');
    if (result.isError) {
      scaffold.showSnackBar(SnackBar(content: Text(result.message)));
      return;
    }

    try {
      var itemList = List.from(result.data)
          .map((item) => MediaDetail.fromJson(item))
          .toList();

      setState(() {
        mediaList = itemList;
      });
    } catch (error) {
      scaffold.showSnackBar(SnackBar(content: Text('Failed parsing data.')));
    }
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
    return Card(
      child: InkWell(
        onTap: () => onStartMedia(media),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: CachedNetworkImage(
                    imageUrl: media.image,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Media Player'),
      ),
      body: Builder(builder: (context) {
        scaffold = Scaffold.of(context);
        return mediaList != null ? buildMediaList() : Text('Loading...');
      }),
    );
  }
}
