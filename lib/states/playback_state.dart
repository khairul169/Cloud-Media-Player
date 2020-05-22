import 'package:cmp/models/media_player_item.dart';
import 'package:cmp/services/media_player.dart';
import 'package:just_audio/just_audio.dart';

class PlaybackState {
  final MediaPlayerItem media;
  final bool playing;
  final bool paused;
  final int duration;
  final int position;
  final AudioRepeatMode repeatMode;

  PlaybackState({
    this.media,
    this.playing = false,
    this.paused = false,
    this.duration = 0,
    this.position = 0,
    this.repeatMode = AudioRepeatMode.None,
  });

  PlaybackState copyWith(MediaPlayerState state) {
    return PlaybackState(
      media: state.media != null ? state.media : null,
      playing: state.state == AudioPlaybackState.playing,
      paused: state.state == AudioPlaybackState.paused,
      duration: state.media?.duration ?? 0,
      position: state.position ?? 0,
      repeatMode: repeatMode,
    );
  }
}
