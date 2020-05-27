import 'package:cmp/models/media.dart';
import 'package:cmp/views/presentation/circle_progress.dart';
import 'package:cmp/views/presentation/media_list_item.dart';
import 'package:flutter/material.dart';

class MediaList extends StatelessWidget {
  final List<Media> items;
  final bool shrinkWrap;
  final Function(int index) onPress;
  final Function(int index) onMenu;

  MediaList({
    Key key,
    this.items,
    this.shrinkWrap,
    this.onPress,
    this.onMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return SizedBox(
        height: 96,
        child: Center(child: CircleProgress(size: 48)),
      );
    }

    if (items.length == 0) {
      return SizedBox(
        height: 96,
        child: Center(child: Text('No Media')),
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap != null && shrinkWrap,
      physics: shrinkWrap != null ? NeverScrollableScrollPhysics() : null,
      itemCount: items.length,
      itemBuilder: (_, index) => MediaListItem(
        item: items[index],
        onPress: onPress != null ? () => onPress(index) : null,
        onMenu: onMenu != null ? () => onMenu(index) : null,
      ),
    );
  }
}
