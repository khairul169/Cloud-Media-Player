import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/api_helper.dart';
import 'package:cmp/services/media_storage.dart';
import 'package:cmp/states/app_state.dart';
import 'package:universal_html/html.dart' as html;

class FetchPlaylists extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    try {
      // Fetch media list
      var result = await APIHelper.get('playlist');
      if (result.isError) throw Exception(result.message);

      // Parse playlists
      var playlists =
          List.from(result.data).map((e) => Playlist.fromJson(e)).toList();

      // Check offline media
      playlists = await Future.wait(playlists.map((item) async {
        return item.copyWith(items: await MediaStorage.checkAll(item.items));
      }));

      // Update state
      dispatch(SetPlaylists(playlists));
    } catch (error) {
      // Error catched
      print(error);
    }

    return null;
  }
}

class PlaylistAddItem extends ReduxAction<AppState> {
  final int index;
  final dynamic item;

  PlaylistAddItem(this.index, this.item);

  Future<void> uploadFileWeb(html.File file) async {
    // Create a placeholder
    var title = file.name;
    placeholder(title.substring(0, title.lastIndexOf('.')));

    var playlist = state.playlists[index];
    var body = {'playlist_id': playlist.id.toString()};

    await Future.delayed(Duration(milliseconds: 500));
    await APIHelper.uploadFile('media/upload', file, body: body);
  }

  void placeholder(String title) {
    var playlist = state.playlists[index];
    var placeholder = Media(title: title, waiting: true);

    // Add placeholder item
    dispatch(PlaylistReplace(
      index,
      playlist.add(placeholder),
    ));
  }

  @override
  Future<AppState> reduce() async {
    if (item is html.File) {
      await uploadFileWeb(item);
    }

    // Refresh playlist
    await dispatchFuture(FetchPlaylists());
    return null;
  }
}

class PlaylistDeleteItem extends ReduxAction<AppState> {
  final int playlistIndex;
  final int index;

  PlaylistDeleteItem(this.playlistIndex, this.index);

  @override
  Future<AppState> reduce() async {
    /*
    // Remove playlist item
    var playlist = state.userPlaylists[playlistIndex];

    dispatch(PlaylistReplace(
      playlistIndex,
      playlist.remove(index),
    ));

    var mediaId = playlist.items[index].id;
    if (mediaId != null) {
      await APIHelper.post('media/delete/$mediaId', null);
    }

    dispatch(FetchPlaylists());
    */
    return null;
  }
}

class PlaylistReplace extends ReduxAction<AppState> {
  final int index;
  final Playlist playlist;

  PlaylistReplace(this.index, this.playlist);

  @override
  AppState reduce() {
    var playlists = state.playlists;
    playlists[index] = playlist;
    return state.copyWith(playlists: playlists);
  }
}

class SetPlaylists extends ReduxAction<AppState> {
  final List<Playlist> items;
  SetPlaylists(this.items);

  @override
  AppState reduce() {
    return state.copyWith(playlists: items);
  }
}
