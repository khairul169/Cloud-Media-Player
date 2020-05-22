import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/services/MediaService.dart';
import 'package:cmp/states/AppState.dart';
import 'package:cmp/states/PlayerState.dart';
import 'package:flutter/material.dart';

class PlaybackPanel extends StatelessWidget {
  const PlaybackPanel({
    Key key,
  }) : super(key: key);

  Widget createWidget({
    String title = '',
    bool playing = false,
    int duration = 0,
    int position = 0,
    Function onPlay,
    Function onStop,
  }) {
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (context, vm) => createWidget(
        title: vm.media?.title ?? '',
        playing: vm.playback.playing,
        duration: vm.playback.duration,
        position: vm.playback.position,
        onPlay: vm.onPlay,
        onStop: vm.onStop,
      ),
    );
  }
}

class ViewModel extends BaseModel<AppState> {
  ViewModel();

  PlayerStateModel playback;
  Media media;
  Function onPlay;
  Function onStop;

  ViewModel.build({
    this.playback,
    this.media,
    this.onPlay,
    this.onStop,
  }) : super(equals: [playback, media]);

  @override
  BaseModel fromStore() {
    var media = state.playerState?.media;
    var playing = state.playerState.playing;

    return ViewModel.build(
      playback: state.playerState,
      media: media,
      onPlay: () => playing ? MediaService.pause() : MediaService.play(),
      onStop: () => MediaService.stop(),
    );
  }
}
