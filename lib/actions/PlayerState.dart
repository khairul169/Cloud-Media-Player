import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/services/MediaPlayer.dart';
import 'package:cmp/services/MediaService.dart';
import 'package:cmp/states/AppState.dart';
import 'package:cmp/states/PlayerState.dart';

class OnPlayerInit extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    // Hook state event
    MediaService.stateEvent.listen((event) {
      dispatch(PlayerStateChange(event));
    });

    // Set repeat mode
    MediaService.setRepeatMode(AudioRepeatMode.All);
    return null;
  }
}

class PlayerStateChange extends ReduxAction<AppState> {
  final MediaPlayerState data;
  PlayerStateChange(this.data);

  @override
  AppState reduce() {
    var playerState = PlayerStateModel.fromMediaState(data);
    return state.copyWith(playerState: playerState);
  }
}

// Playlist
class SetPlaylist extends ReduxAction<AppState> {
  final Playlist playlist;
  final int playId;
  SetPlaylist(this.playlist, {this.playId});

  @override
  AppState reduce() {
    MediaService.setPlaylist(playlist);
    if (playId != null) MediaService.playIndex(playId);
    return state.copyWith(playlist: playlist);
  }
}
