import 'package:cmp/views/containers/playback_panel_view.dart';
import 'package:flutter/material.dart';

class PlaybackPanelWrap extends StatelessWidget {
  final Widget child;

  PlaybackPanelWrap({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: child),
        PlaybackPanelView(),
      ],
    );
  }
}
