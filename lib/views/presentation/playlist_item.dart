import 'package:cmp/views/presentation/action_button.dart';
import 'package:cmp/views/presentation/circle_shape.dart';
import 'package:flutter/material.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({
    Key key,
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
                  Text('Playlist'),
                  SizedBox(height: 4),
                  Text(
                    'Glow, AI Kotoba, ...',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            Text(
              '0:00',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            SizedBox(width: 8),
            ActionButton(
              icon: Icons.play_arrow,
              onPress: () {},
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
