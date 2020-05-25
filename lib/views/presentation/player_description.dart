import 'package:cmp/services/media_player.dart';
import 'package:flutter/material.dart';

class PlayerDescription extends StatelessWidget {
  final MediaPlayerItem media;
  final VoidCallback onSkipPrev;
  final VoidCallback onSkipNext;

  const PlayerDescription({
    Key key,
    this.media,
    this.onSkipPrev,
    this.onSkipNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Dismissible(
        key: Key("skip"),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd && onSkipPrev != null) {
            onSkipPrev();
          }
          if (direction == DismissDirection.endToStart && onSkipNext != null) {
            onSkipNext();
          }
          return false;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCoverImage(constraints),
              SizedBox(height: 32),
              Text(
                media.title ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 12),
              Text(
                media.artist ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  ClipRRect buildCoverImage(BoxConstraints constraints) {
    var maxSize = (constraints.maxWidth > constraints.maxHeight)
        ? constraints.maxHeight
        : constraints.maxWidth;
    var imageSize = maxSize * 0.6;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: (media != null)
            ? Image.network(media.image, fit: BoxFit.cover)
            : Container(),
      ),
    );
  }
}
