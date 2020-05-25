import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  final String title;
  final bool current;
  final VoidCallback onPress;

  const NavigationItem({
    Key key,
    @required this.title,
    this.current = false,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = TextStyle(
      color: current ? Colors.white : Colors.white.withOpacity(0.6),
      fontSize: 14,
      letterSpacing: 1,
    );
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 48,
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: titleStyle),
            buildIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context) {
    if (!current) return Container();
    return Container(
      margin: EdgeInsets.only(left: 2, top: 12),
      child: CircleShape(
        color: Theme.of(context).primaryColorLight.withOpacity(0.8),
        size: 6,
      ),
    );
  }
}
