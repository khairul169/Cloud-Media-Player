import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/states/playback_state.dart';
import 'package:cmp/views/presentation/playback_panel.dart';
import 'package:cmp/views/screens/player_screen.dart';
import 'package:flutter/material.dart';

class PlaybackPanelView extends StatelessWidget {
  const PlaybackPanelView({
    Key key,
  }) : super(key: key);

  void onPanelPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlayerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (context, vm) {
        // State from store
        var state = vm.playback;
        var progress = (state.duration != null && state.duration > 0.0)
            ? state.position / state.duration
            : null;

        // Build widget
        return PlaybackPanel(
          media: state.media,
          playing: state.playing,
          progress: progress,
          onPlay: vm.onPlay,
          onSkip: vm.onSkip,
          onPress: () => onPanelPressed(context),
        );
      },
    );
  }
}

class ViewModel extends BaseModel<AppState> {
  ViewModel();

  PlaybackState playback;
  Function onPlay;
  Function onSkip;

  ViewModel.build({
    this.playback,
    this.onPlay,
    this.onSkip,
  }) : super(equals: [playback]);

  @override
  BaseModel fromStore() {
    var playing = state.playback.playing;

    return ViewModel.build(
      playback: state.playback,
      onPlay: () {
        if (playing) {
          dispatch(SetPlaybackPause());
        } else {
          dispatch(SetPlaybackPlay());
        }
      },
      onSkip: () {
        dispatch(SetPlaybackSkip());
      },
    );
  }
}
