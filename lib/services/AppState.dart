import 'package:cmp/models/Media.dart';

class AppState {
  final MediaList mediaList;

  AppState({this.mediaList});

  factory AppState.initialState() => AppState();

  AppState copyWith({MediaList mediaList}) => AppState(
        mediaList: mediaList ?? this.mediaList,
      );
}
