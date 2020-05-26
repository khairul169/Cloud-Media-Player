import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/api_helper.dart';
import 'package:cmp/services/media_storage.dart';
import 'package:cmp/states/app_state.dart';

class FetchUserPlaylist extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    try {
      // Fetch media list
      var result = await APIHelper.get('media');
      if (result.isError) throw Exception(result.message);

      var playlist = Playlist.fromJson(result.data);

      // Check offline availability
      playlist = playlist.copyWith(
        items: await MediaStorage.checkAll(playlist.items),
      );

      // Update state
      dispatch(SetUserPlaylists([playlist]));
    } catch (error) {
      // Error catched
      print(error);
    }

    return null;
  }
}

class ReplaceUserPlaylist extends ReduxAction<AppState> {
  final int index;
  final Playlist playlist;

  ReplaceUserPlaylist(this.index, this.playlist);

  @override
  AppState reduce() {
    var playlists = state.userPlaylists;
    playlists[index] = playlist;
    return state.copyWith(userPlaylists: playlists);
  }
}

class DeleteUserPlaylistItem extends ReduxAction<AppState> {
  final int playlistIndex;
  final int index;

  DeleteUserPlaylistItem(this.playlistIndex, this.index);

  @override
  AppState reduce() {
    var playlists = state.userPlaylists;
    var removed = playlists[playlistIndex].removeItem(index);

    // Replace playlist
    dispatch(ReplaceUserPlaylist(playlistIndex, removed));
    return null;
  }
}

class SetUserPlaylists extends ReduxAction<AppState> {
  final List<Playlist> items;
  SetUserPlaylists(this.items);

  @override
  AppState reduce() {
    return state.copyWith(userPlaylists: items);
  }
}
