import 'package:cmp/views/presentation/browse_nav_item.dart';
import 'package:flutter/material.dart';

class BrowseNavigation extends StatelessWidget {
  const BrowseNavigation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrowseNavigationItem(title: 'LIBRARY', current: true),
        BrowseNavigationItem(title: 'DISCOVERY'),
      ],
    );
  }
}
