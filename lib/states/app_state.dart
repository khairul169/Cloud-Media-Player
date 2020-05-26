import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/playback_state.dart';

class AppState {
  /// Media player state
  final PlaybackState playback;
  final Playlist playbackList;

  /// User playlist
  final List<Playlist> userPlaylists;

  AppState({
    this.playback,
    this.playbackList,
    this.userPlaylists,
  });

  factory AppState.initialState() {
    return AppState(
      playback: PlaybackState(),
      playbackList: Playlist(),
      userPlaylists: null,
    );
  }

  AppState copyWith({
    PlaybackState playback,
    Playlist playbackList,
    List<Playlist> userPlaylists,
  }) {
    return AppState(
      playback: playback ?? this.playback,
      playbackList: playbackList ?? this.playbackList,
      userPlaylists: userPlaylists ?? this.userPlaylists,
    );
  }
}
