import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/playback_state.dart';

class AppState {
  /// Media player state
  final PlaybackState playback;
  final Playlist playlist;

  /// User playlist
  final List<Playlist> userPlaylists;

  AppState({
    this.playback,
    this.playlist,
    this.userPlaylists,
  });

  factory AppState.initialState() {
    return AppState(
      playback: PlaybackState(),
      playlist: Playlist(),
      userPlaylists: null,
    );
  }

  AppState copyWith({
    PlaybackState playback,
    Playlist playlist,
    List<Playlist> userPlaylists,
  }) {
    return AppState(
      playback: playback ?? this.playback,
      playlist: playlist ?? this.playlist,
      userPlaylists: userPlaylists ?? this.userPlaylists,
    );
  }
}
