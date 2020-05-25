import 'package:cmp/public/utils.dart';
import 'package:cmp/services/media_player.dart';
import 'package:cmp/views/presentation/action_button.dart';
import 'package:flutter/material.dart';

class PlaybackPanel extends StatelessWidget {
  final MediaPlayerItem media;
  final bool playing;
  final double progress;
  final VoidCallback onPlay;
  final VoidCallback onPress;
  final VoidCallback onSkip;

  PlaybackPanel({
    this.media,
    this.playing,
    this.progress,
    this.onPlay,
    this.onPress,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Empty media
    if (media == null) {
      return Container();
    }

    return GestureDetector(
      child: Container(
        height: 66,
        color: theme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProgressBar(context, progress),
            Expanded(
              flex: 1,
              child: buildPanel(context, theme),
            ),
          ],
        ),
      ),
      onTap: onPress,
      onPanUpdate: (details) {
        if (details.delta.dy < 0 && onPress != null) {
          onPress();
        }
      },
    );
  }

  Widget buildProgressBar(BuildContext context, [double progress]) {
    return LayoutBuilder(
      builder: (_, constraints) => SizedBox(
        height: 2,
        child: Container(
          color: Theme.of(context).accentColor,
          height: 2,
          width: constraints.maxWidth * (progress ?? 0.0),
        ),
      ),
    );
  }

  Widget buildPanel(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(left: 18, right: 12),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: buildCoverImage(),
          ),
          SizedBox(width: 18),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Now Playing',
                    style: theme.textTheme.caption,
                  ),
                ),
                Text(
                  getTitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          ActionButton(
            icon: playing ? Icons.pause : Icons.play_arrow,
            onPress: onPlay,
            size: 40,
          ),
          ActionButton(
            icon: Icons.skip_next,
            onPress: onSkip,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget buildCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.network(media.image, fit: BoxFit.cover),
    );
  }

  String getTitle() {
    if (Utils.isEmpty(media.artist))
      return media.title;
    else
      return '${media.title} - ${media.artist}';
  }
}
