import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/states/playback_state.dart';

class AppState {
  final List<Media> mediaList;
  final PlaybackState playback;
  final Playlist playlist;

  AppState({
    this.mediaList,
    this.playback,
    this.playlist,
  });

  factory AppState.initialState() => AppState(
        mediaList: List<Media>(),
        playback: PlaybackState(),
        playlist: Playlist(),
      );

  AppState copyWith({
    List<Media> mediaList,
    PlaybackState playback,
    Playlist playlist,
  }) =>
      AppState(
        mediaList: mediaList ?? this.mediaList,
        playback: playback ?? this.playback,
        playlist: playlist ?? this.playlist,
      );
}
