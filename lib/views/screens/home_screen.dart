import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/containers/playback_panel_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
            child: MediaListView(),
          ),
          PlaybackPanelView(),
        ],
      ),
    );
  }
}
