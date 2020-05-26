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
            CircleShape(
              size: 36,
              child: item.image != null
                  ? Image.network(
                      item.image,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.music_note, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: buildDescription(),
            ),
            buildIndicator(),
            SizedBox(width: 16),
            Text(
              Utils.timeToString(item.duration.toInt()),
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
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
      return Container(
        margin: EdgeInsets.only(left: 16),
        child: CircleProgress(),
      );
    }

    // Downloaded
    if (item.localPath != null) {
      return Container(
        margin: EdgeInsets.only(left: 16),
        child: CircleShape(
          color: Colors.green,
          child: Icon(Icons.file_download, size: 14),
          size: 24,
        ),
      );
    }

    // No indicator
    return Container();
  }
}
