import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/media_player.dart';
import 'package:cmp/services/media_service.dart';
import 'package:cmp/states/app_state.dart';

class OnPlayerInit extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    // Hook state event
    MediaService.stateEvent.listen((event) {
      dispatch(PlayerStateChange(event));
    });

    // Initial repeat mode
    var repeatMode = state.playback.repeatMode;
    dispatch(SetPlaybackRepeat(repeatMode));
    return null;
  }
}

class PlayerStateChange extends ReduxAction<AppState> {
  final MediaPlayerState data;
  PlayerStateChange(this.data);

  @override
  AppState reduce() {
    var playback = state.playback.copyWith(data);
    return state.copyWith(playback: playback);
  }
}

class SetPlaybackPlay extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    MediaService.play();
    return null;
  }
}

class SetPlaybackPause extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    MediaService.pause();
    return null;
  }
}

class SetPlaybackStop extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    MediaService.stop();
    return null;
  }
}

class SetPlaybackRepeat extends ReduxAction<AppState> {
  final AudioRepeatMode mode;
  SetPlaybackRepeat(this.mode);

  @override
  AppState reduce() {
    MediaService.setRepeatMode(mode);
    return null;
  }
}

// Playlist
class SetPlaylist extends ReduxAction<AppState> {
  final Playlist playlist;
  final int playId;
  SetPlaylist(this.playlist, {this.playId});

  @override
  AppState reduce() {
    MediaService.setPlaylist(playlist.toMediaQueue());
    if (playId != null) MediaService.playIndex(playId);
    return state.copyWith(playlist: playlist);
  }
}
