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
    var playback = state.playback.copyMediaState(data);
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

class SetPlaybackSkip extends ReduxAction<AppState> {
  final bool prev;
  SetPlaybackSkip({this.prev = false});

  @override
  AppState reduce() {
    if (prev) {
      MediaService.prev();
    } else {
      MediaService.next();
    }
    return null;
  }
}

class SetPlaybackRepeat extends ReduxAction<AppState> {
  final AudioRepeatMode mode;
  SetPlaybackRepeat([this.mode]);

  @override
  AppState reduce() {
    var repeatMode = state.playback.repeatMode;

    if (mode == null) {
      switch (repeatMode) {
        case AudioRepeatMode.None:
          repeatMode = AudioRepeatMode.Single;
          break;
        case AudioRepeatMode.Single:
          repeatMode = AudioRepeatMode.All;
          break;
        default:
          repeatMode = AudioRepeatMode.None;
          break;
      }
    } else {
      repeatMode = mode;
    }

    MediaService.setRepeatMode(repeatMode);
    var playback = state.playback.copyWith(repeatMode: repeatMode);
    return state.copyWith(playback: playback);
  }
}

// Playlist
class SetPlaybackList extends ReduxAction<AppState> {
  final Playlist playlist;
  final int playId;

  SetPlaybackList(this.playlist, {this.playId});

  @override
  AppState reduce() {
    // Set playlist
    MediaService.setPlaylist(playlist.toMediaQueue());

    // Play media
    if (playId != null) {
      MediaService.playIndex(playId);
    }
    return state.copyWith(playbackList: playlist);
  }
}
