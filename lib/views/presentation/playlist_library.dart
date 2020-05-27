import 'package:cmp/models/playlist.dart';
import 'package:cmp/views/presentation/circle_progress.dart';
import 'package:cmp/views/presentation/playlist_item.dart';
import 'package:flutter/material.dart';

class PlaylistLibrary extends StatelessWidget {
  final List<Playlist> items;
  final Function(Playlist playlist) onPress;
  final Function(Playlist playlist) onPlay;

  const PlaylistLibrary({
    Key key,
    @required this.items,
    @required this.onPress,
    @required this.onPlay,
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
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, index) {
        var item = items[index];
        return PlaylistItem(
          item: item,
          onPress: () => onPress(item),
          onPlay: () => onPlay(item),
        );
      },
    );
  }
}
