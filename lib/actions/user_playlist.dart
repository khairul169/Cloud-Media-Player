import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/services/api_helper.dart';
import 'package:cmp/services/offline_media_service.dart';
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
        items: await OfflineMediaService.checkAll(playlist.items),
      );

      // Update state
      dispatch(SetUserPlaylist([playlist]));
    } catch (error) {
      // Error catched
      print(error);
    }

    return null;
  }
}

class SetUserPlaylist extends ReduxAction<AppState> {
  final List<Playlist> playlist;
  SetUserPlaylist(this.playlist);

  @override
  Future<AppState> reduce() async {
    return state.copyWith(userPlaylists: playlist);
  }
}
