import 'package:cmp/models/media.dart';
import 'package:cmp/public/utils.dart';
import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final Media item;
  final VoidCallback onPress;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  const MediaListItem({
    Key key,
    this.item,
    this.onPress,
    this.onDownload,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 16),
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
            item.local
                ? CircleShape(
                    color: Colors.green,
                    child: Icon(Icons.file_download, size: 16),
                    size: 28,
                  )
                : Container(),
            PopupMenuButton(
              icon: Icon(Icons.more_vert, size: 20),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 0,
                  child: Text(
                    item.local ? 'Remove Download' : 'Download Media',
                  ),
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Delete'),
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
              ],
              onSelected: (id) {
                if (id == 0 && onDownload != null) {
                  onDownload();
                }
                if (id == 1 && onDelete != null) {
                  onDelete();
                }
              },
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
