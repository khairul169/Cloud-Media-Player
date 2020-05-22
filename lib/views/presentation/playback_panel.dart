import 'package:flutter/material.dart';

class PlaybackPanel extends StatelessWidget {
  final String title;
  final bool playing;
  final int duration;
  final int position;
  final VoidCallback onPlay;
  final VoidCallback onStop;

  PlaybackPanel({
    this.title,
    this.playing,
    this.duration,
    this.position,
    this.onPlay,
    this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Title: $title'),
                Text('Position: $position'),
                Text('Duration: $duration'),
              ],
            ),
          ),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.green,
            child: Icon(playing ? Icons.pause : Icons.play_arrow),
            onPressed: onPlay,
          ),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.red,
            child: Icon(Icons.stop),
            onPressed: onStop,
          ),
        ],
      ),
    );
  }
}
