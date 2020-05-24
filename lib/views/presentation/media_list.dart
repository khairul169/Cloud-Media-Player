import 'package:cmp/models/media.dart';
import 'package:cmp/views/presentation/media_list_item.dart';
import 'package:flutter/material.dart';

class MediaList extends StatelessWidget {
  final List<Media> items;
  final Function(int index) onItemPress;
  final Function(int index) onItemDownload;
  final Function(int index) onItemDelete;

  const MediaList({
    Key key,
    @required this.items,
    @required this.onItemPress,
    @required this.onItemDownload,
    @required this.onItemDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, index) {
        var item = items[index];
        return MediaListItem(
          item: item,
          onPress: () => onItemPress(index),
          onDownload: () => onItemDownload(index),
          onDelete: () => onItemDelete(index),
        );
      },
    );
  }
}
