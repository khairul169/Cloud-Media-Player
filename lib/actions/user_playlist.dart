import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/api_helper.dart';
import 'package:cmp/services/media_storage.dart';
import 'package:cmp/states/app_state.dart';
import 'package:universal_html/html.dart' as html;

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

class UserPlaylistAddItem extends ReduxAction<AppState> {
  final int index;
  final dynamic item;

  UserPlaylistAddItem(this.index, this.item);

  Future<void> uploadFileWeb(html.File file) async {
    // Create a placeholder
    placeholder(file.name);

    await Future.delayed(Duration(milliseconds: 500));

    var result = await APIHelper.uploadFile('media/upload', file);
    print(result.body);
  }

  void placeholder(String title) {
    var playlist = state.userPlaylists[index];
    var placeholder = Media(title: title, waiting: true);

    // Add placeholder item
    dispatch(UserPlaylistReplace(
      index,
      playlist.add(placeholder),
    ));
  }

  @override
  Future<AppState> reduce() async {
    if (item is html.File) {
      await uploadFileWeb(item);
    }
    dispatch(FetchUserPlaylist());
    return null;
  }
}

class UserPlaylistReplace extends ReduxAction<AppState> {
  final int index;
  final Playlist playlist;

  UserPlaylistReplace(this.index, this.playlist);

  @override
  AppState reduce() {
    var playlists = state.userPlaylists;
    playlists[index] = playlist;
    return state.copyWith(userPlaylists: playlists);
  }
}

class UserPlaylistDeleteItem extends ReduxAction<AppState> {
  final int playlistIndex;
  final int index;

  UserPlaylistDeleteItem(this.playlistIndex, this.index);

  @override
  AppState reduce() {
    // Remove playlist item
    var playlist = state.userPlaylists[playlistIndex];
    dispatch(UserPlaylistReplace(playlistIndex, playlist.remove(index)));
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
