import 'package:cmp/helpers/ApiHelper.dart';
import 'package:cmp/models/MediaDetail.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String test;
  MediaDetail media;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var result = await ApiHelper.get('media/detail/13');
    if (result.isError) {
      print('error ' + result.message);
      return;
    }

    var data = MediaDetail.fromJson(result.data);
    setState(() {
      media = data;
    });
  }

  Widget buildMediaLayout() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 200,
          child: Image.network(media.image, fit: BoxFit.cover),
        ),
        Text('Title: ' + media.title),
        Text('Artist: ' + media.artist),
        Text('Album: ' + media.album),
        Text('Year: ' + media.year.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Media Player'),
      ),
      body: media != null ? buildMediaLayout() : Text('Loading...'),
    );
  }
}
