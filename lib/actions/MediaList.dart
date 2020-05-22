import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/services/APIHelper.dart';
import 'package:cmp/states/AppState.dart';

class FetchMediaList extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    try {
      // Fetch media list
      var result = await APIHelper.get('media');
      if (result.isError) throw Exception(result.message);

      var itemList = MediaList.fromJson(result.data);

      // Update state
      dispatch(SetMediaList(itemList));
    } catch (error) {
      // Error catched
      print(error);
    }

    return null;
  }
}

class SetMediaList extends ReduxAction<AppState> {
  final MediaList items;

  SetMediaList(this.items);

  @override
  AppState reduce() {
    return state.copyWith(mediaList: items);
  }
}
