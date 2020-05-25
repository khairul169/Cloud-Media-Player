import 'package:cmp/public/utils.dart';
import 'package:cmp/services/media_player.dart';
import 'package:cmp/views/presentation/action_button.dart';
import 'package:flutter/material.dart';

class PlaybackPanel extends StatelessWidget {
  final MediaPlayerItem media;
  final bool playing;
  final VoidCallback onPlay;
  final VoidCallback onPress;

  PlaybackPanel({
    this.media,
    this.playing,
    this.onPlay,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Empty media
    if (media == null) {
      return Container();
    }

    return SizedBox(
      height: 75,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: theme.primaryColorDark.withOpacity(0.6),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: buildCoverImage(),
              ),
              SizedBox(width: 16),
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
                color: theme.primaryColor,
                size: 40,
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
