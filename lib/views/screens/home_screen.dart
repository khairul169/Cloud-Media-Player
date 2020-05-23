import 'package:cmp/views/containers/media_list_view.dart';
import 'package:cmp/views/containers/playback_panel_view.dart';
import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
              child: Container(
                padding: EdgeInsets.all(16),
                child: buildContent(context),
              ),
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
        Text('Browse', style: Theme.of(context).textTheme.headline1),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationItem(title: 'LIBRARY', current: true),
            NavigationItem(title: 'DISCOVERY'),
          ],
        ),
        SizedBox(height: 24),
        MediaListView(),
      ],
    );
  }
}

class NavigationItem extends StatelessWidget {
  final String title;
  final bool current;

  const NavigationItem({
    Key key,
    @required this.title,
    this.current = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.subtitle2;
    titleStyle = titleStyle.copyWith(
      color: current ? titleStyle.color : titleStyle.color.withOpacity(0.6),
    );
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          buildIndicator(context),
        ],
      ),
    );
  }

  Widget buildIndicator(BuildContext context) {
    if (!current) return Container();
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: CircleShape(
        color: Theme.of(context).primaryColorLight.withOpacity(0.8),
        size: 4,
      ),
    );
  }
}
