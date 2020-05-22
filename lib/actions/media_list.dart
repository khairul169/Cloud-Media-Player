import 'package:async_redux/async_redux.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/services/api_helper.dart';
import 'package:cmp/states/app_state.dart';

class FetchMediaList extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    try {
      // Fetch media list
      var result = await APIHelper.get('media');
      if (result.isError) throw Exception(result.message);

      var itemList =
          List.from(result.data).map((e) => Media.fromJson(e)).toList();

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
  final List<Media> items;

  SetMediaList(this.items);

  @override
  AppState reduce() {
    return state.copyWith(mediaList: items);
  }
}
