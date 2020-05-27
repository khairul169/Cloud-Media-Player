import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/playback_state.dart';

class AppState {
  /// Media player state
  final PlaybackState playback;
  final Playlist playbackList;

  /// User playlist
  final List<Playlist> playlists;

  AppState({
    this.playback,
    this.playbackList,
    this.playlists,
  });

  factory AppState.initialState() {
    return AppState(
      playback: PlaybackState(),
      playbackList: Playlist(),
      playlists: null,
    );
  }

  AppState copyWith({
    PlaybackState playback,
    Playlist playbackList,
    List<Playlist> playlists,
  }) {
    return AppState(
      playback: playback ?? this.playback,
      playbackList: playbackList ?? this.playbackList,
      playlists: playlists ?? this.playlists,
    );
  }
}
