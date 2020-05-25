import 'package:cmp/views/presentation/navigation_item.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final List<String> items;
  final int current;
  final Function(int index) onSelect;

  const NavigationBar({
    Key key,
    this.items,
    this.current = 0,
    @required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items != null ? buildNavItems() : [],
    );
  }

  List<Widget> buildNavItems() {
    return items
        .asMap()
        .map((index, value) => MapEntry(
            index,
            NavigationItem(
              title: value,
              current: index == current,
              onPress: () => onSelect(index),
            )))
        .values
        .toList();
  }
}
