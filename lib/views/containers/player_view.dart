import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/models/media_player_item.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/states/playback_state.dart';
import 'package:cmp/views/presentation/player_controller.dart';
import 'package:cmp/views/presentation/player_description.dart';
import 'package:cmp/views/presentation/player_progress.dart';
import 'package:flutter/material.dart';

class PlayerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (context, vm) => Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: PlayerDescription(
                media: vm.media,
                onSkipPrev: vm.onSkipPrev,
                onSkipNext: vm.onSkipNext,
              ),
            ),
          ),
          Column(
            children: [
              PlayerProgress(
                duration: vm.playback.duration,
                position: vm.playback.position,
              ),
              PlayerController(
                playing: vm.playback.playing,
                repeatMode: vm.playback.repeatMode,
                onSkipPrev: vm.onSkipPrev,
                onPlay: vm.onPlay,
                onSkipNext: vm.onSkipNext,
                onShuffle: vm.onShuffle,
                onRepeat: vm.onRepeat,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewModel extends BaseModel<AppState> {
  final PlaybackState playback;
  final Function onPlay;
  final Function onSkipNext;
  final Function onSkipPrev;
  final Function onShuffle;
  final Function onRepeat;

  ViewModel({
    this.playback,
    this.onPlay,
    this.onSkipNext,
    this.onSkipPrev,
    this.onShuffle,
    this.onRepeat,
  }) : super(equals: [playback]);

  MediaPlayerItem get media => playback.media;

  @override
  BaseModel fromStore() {
    var playing = state.playback.playing;

    return ViewModel(
      playback: state.playback,
      onPlay: () {
        if (playing) {
          dispatch(SetPlaybackPause());
        } else {
          dispatch(SetPlaybackPlay());
        }
      },
      onSkipNext: () => dispatch(SetPlaybackSkip()),
      onSkipPrev: () => dispatch(SetPlaybackSkip(prev: true)),
      onRepeat: () => dispatch(SetPlaybackRepeat()),
    );
  }
}
