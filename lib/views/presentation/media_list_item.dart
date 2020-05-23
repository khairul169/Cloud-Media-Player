import 'package:cmp/models/media.dart';
import 'package:cmp/public/utils.dart';
import 'package:cmp/views/presentation/action_button.dart';
import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final Media item;
  final VoidCallback onPress;

  const MediaListItem({
    Key key,
    this.item,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
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
            Text(Utils.timeToString(item.duration)),
            SizedBox(width: 16),
            ActionButton(
              icon: Icons.favorite_border,
              onPress: () {},
            ),
          ],
        ),
      ),
      onTap: onPress,
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
        !Utils.isEmpty(item.artist)
            ? Container(
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  item.artist,
                  style: TextStyle(fontSize: 11),
                ),
              )
            : Container(),
      ],
    );
  }
}
