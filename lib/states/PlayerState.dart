import 'package:cmp/models/Media.dart';
import 'package:cmp/services/MediaPlayer.dart';
import 'package:just_audio/just_audio.dart';

class PlayerStateModel {
  final Media media;
  final bool playing;
  final bool paused;
  final int duration;
  final int position;

  PlayerStateModel({
    this.media,
    this.playing = false,
    this.paused = false,
    this.duration = 0,
    this.position = 0,
  });

  factory PlayerStateModel.fromMediaState(MediaPlayerState state) =>
      PlayerStateModel(
        media: state.media != null ? Media.fromMediaItem(state.media) : null,
        playing: state.state == AudioPlaybackState.playing,
        paused: state.state == AudioPlaybackState.paused,
        duration: state.media?.duration ?? 0,
        position: state.position ?? 0,
      );

  copyWith({
    Media media,
    bool playing,
    bool paused,
    int duration,
    int position,
  }) =>
      PlayerStateModel(
        media: media ?? this.media,
        playing: playing ?? this.playing,
        paused: paused ?? this.paused,
        duration: duration ?? this.duration,
        position: position ?? this.position,
      );
}
