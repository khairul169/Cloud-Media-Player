import 'package:cmp/views/presentation/playlist_item.dart';
import 'package:flutter/material.dart';

class PlaylistLibrary extends StatelessWidget {
  const PlaylistLibrary({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, index) {
        return PlaylistItem();
      },
    );
  }
}
