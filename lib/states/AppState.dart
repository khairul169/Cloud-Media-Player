import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/states/PlayerState.dart';

class AppState {
  final MediaList mediaList;
  final PlayerStateModel playerState;
  final Playlist playlist;

  AppState({
    this.mediaList,
    this.playerState,
    this.playlist,
  });

  factory AppState.initialState() => AppState(
        mediaList: MediaList(),
        playerState: PlayerStateModel(),
        playlist: Playlist(),
      );

  AppState copyWith({
    MediaList mediaList,
    PlayerStateModel playerState,
    Playlist playlist,
  }) =>
      AppState(
        mediaList: mediaList ?? this.mediaList,
        playerState: playerState ?? this.playerState,
        playlist: playlist ?? this.playlist,
      );
}
