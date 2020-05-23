import 'package:cmp/services/media_player.dart';
import 'package:cmp/views/presentation/action_button.dart';
import 'package:flutter/material.dart';

class PlayerController extends StatelessWidget {
  final bool playing;
  final AudioRepeatMode repeatMode;

  final VoidCallback onSkipPrev;
  final VoidCallback onPlay;
  final VoidCallback onSkipNext;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;

  const PlayerController({
    Key key,
    this.playing = false,
    this.repeatMode,
    this.onSkipPrev,
    this.onPlay,
    this.onSkipNext,
    this.onShuffle,
    this.onRepeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            icon: Icons.shuffle,
            onPress: onShuffle,
          ),
          Center(
            child: buildMainControl(context),
          ),
          buildRepeatButton(context),
        ],
      ),
    );
  }

  Row buildMainControl(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          icon: Icons.skip_previous,
          size: 56,
          onPress: onSkipPrev,
        ),
        ActionButton(
          icon: playing ? Icons.pause : Icons.play_arrow,
          size: 64,
          color: Theme.of(context).accentColor,
          onPress: onPlay,
        ),
        ActionButton(
          icon: Icons.skip_next,
          size: 56,
          onPress: onSkipNext,
        ),
      ],
    );
  }

  Widget buildRepeatButton(BuildContext context) {
    if (repeatMode == AudioRepeatMode.All ||
        repeatMode == AudioRepeatMode.Single) {
      return ActionButton(
        icon: (repeatMode == AudioRepeatMode.All)
            ? Icons.repeat
            : Icons.repeat_one,
        onPress: onRepeat,
      );
    }
    return ActionButton(
      icon: Icons.repeat,
      iconColor: Theme.of(context).primaryColorLight.withOpacity(0.6),
      onPress: onRepeat,
    );
  }
}
