import 'package:cmp/models/playlist.dart';
import 'package:cmp/public/utils.dart';
import 'package:cmp/views/presentation/action_button.dart';
import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class PlaylistItem extends StatelessWidget {
  final Playlist item;
  final Function onPress;
  final Function onPlay;

  const PlaylistItem({
    Key key,
    this.item,
    this.onPress,
    this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Row(
          children: [
            CircleShape(
              size: 36,
              color: Theme.of(context).cardColor,
              child: Icon(Icons.music_note, size: 18),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title ?? 'Playlist'),
                  SizedBox(height: 4),
                  Text(
                    item.subtitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            Text(
              Utils.timeToString(item.playTime),
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            SizedBox(width: 8),
            ActionButton(
              icon: Icons.play_arrow,
              onPress: onPlay,
            )
          ],
        ),
      ),
      onTap: onPress,
    );
  }
}
