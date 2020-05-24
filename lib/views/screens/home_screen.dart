import 'package:async_redux/async_redux.dart';
import 'package:cmp/actions/media_list.dart';
import 'package:cmp/models/media.dart';
import 'package:cmp/states/app_state.dart';
import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/containers/playback_panel_view.dart';
import 'package:cmp/views/presentation/browse_navigation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    StoreProvider.dispatch(context, FetchMediaList());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: buildContent(context),
            ),
          ),
          PlaybackPanelView(),
        ],
      ),
    );
  }

  Column buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Browse', style: Theme.of(context).textTheme.headline1),
              SizedBox(height: 24),
              BrowseNavigation(),
            ],
          ),
        ),
        StoreConnector<AppState, List<Media>>(
          converter: (store) => store.state.mediaList,
          builder: (_, items) => MediaListView(items: items),
        ),
      ],
    );
  }
}
