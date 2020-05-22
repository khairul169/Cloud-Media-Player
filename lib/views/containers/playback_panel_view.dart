import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/playback.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/states/playback_state.dart';
import 'package:cmp/views/presentation/playback_panel.dart';
import 'package:flutter/material.dart';

class PlaybackPanelView extends StatelessWidget {
  const PlaybackPanelView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      model: ViewModel(),
      builder: (context, vm) {
        // State from store
        var state = vm.playback;
        var title = state.media?.title ?? '';

        // Build widget
        return PlaybackPanel(
          title: title,
          playing: state.playing,
          duration: state.duration,
          position: state.position,
          onPlay: vm.onPlay,
          onStop: vm.onStop,
        );
      },
    );
  }
}

class ViewModel extends BaseModel<AppState> {
  ViewModel();

  PlaybackState playback;
  Function onPlay;
  Function onStop;

  ViewModel.build({
    this.playback,
    this.onPlay,
    this.onStop,
  }) : super(equals: [playback]);

  @override
  BaseModel fromStore() {
    var playing = state.playback.playing;

    return ViewModel.build(
      playback: state.playback,
      onPlay: () {
        if (playing)
          dispatch(SetPlaybackPause());
        else
          dispatch(SetPlaybackPlay());
      },
      onStop: () {
        dispatch(SetPlaybackStop());
      },
    );
  }
}
