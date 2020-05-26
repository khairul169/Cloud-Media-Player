import 'package:cmp/models/media.dart';
import 'package:cmp/public/utils.dart';
import 'package:cmp/views/presentation/action_button.dart';
import 'package:cmp/views/presentation/circle_progress.dart';
import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final Media item;
  final VoidCallback onPress;
  final VoidCallback onMenu;

  const MediaListItem({
    Key key,
    this.item,
    this.onPress,
    this.onMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      onLongPress: onMenu,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Row(
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: buildDescription(),
            ),
            SizedBox(width: 16),
            buildIndicator(),
            SizedBox(width: 8),
            ActionButton(
              icon: Icons.favorite_border,
              onPress: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
        Utils.isEmpty(item.artist)
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(item.artist, style: TextStyle(fontSize: 12)),
              ),
      ],
    );
  }

  Widget buildIndicator() {
    // Progress
    if (item.waiting) {
      return CircleProgress();
    }

    // Downloaded
    if (item.local) {
      return CircleShape(
        color: Colors.green,
        child: Icon(Icons.file_download, size: 14),
        size: 24,
      );
    }

    // No indicator
    return Container();
  }
}
