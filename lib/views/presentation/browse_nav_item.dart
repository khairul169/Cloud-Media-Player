import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class BrowseNavigationItem extends StatelessWidget {
  final String title;
  final bool current;

  const BrowseNavigationItem({
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
