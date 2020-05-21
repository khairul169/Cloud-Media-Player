import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:cmp/services/MediaPlayer.dart';
import 'package:just_audio/just_audio.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);

MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);

MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);

MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);

MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

void audioTaskEntry() {
  AudioServiceBackground.run(() => BackgroundAudioService());
}

class BackgroundAudioService extends BackgroundAudioTask {
  final completer = Completer();
  final player = MediaPlayer();

  MediaItem _media;

  static Future<bool> start() async {
    // Start audio service
    return await AudioService.start(
      backgroundTaskEntrypoint: audioTaskEntry,
      androidNotificationChannelName: 'Cloud Media Player',
      notificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      enableQueue: true,
    );
  }

  @override
  Future<void> onStart() async {
    var cleanListener = player.init();
    player.stateEvent.listen(onStateChange);
    await completer.future;
    cleanListener();
  }

  @override
  void onPlay() {
    player.play();
  }

  @override
  void onStop() {
    player.stop();
  }

  @override
  void onPause() {
    player.pause();
  }

  @override
  void onSkipToNext() {
    player.skipToNext();
  }

  @override
  void onSkipToPrevious() {
    player.skipToPrevious();
  }

  @override
  void onPlayMediaItem(MediaItem media) {
    player.playMediaItem(media);
  }

  @override
  Future<void> onReplaceQueue(List<MediaItem> items) async {
    player.setQueue(items);
  }

  @override
  void onPlayFromMediaId(String mediaId) {
    try {
      var id = int.tryParse(mediaId, radix: 10);
      player.playMediaId(id);
    } catch (error) {
      print(error);
    }
  }

  @override
  Future onCustomAction(String name, arguments) async {
    switch (name) {
      case 'setRepeatMode':
        return onSetRepeatMode(arguments);
        break;
      default:
        break;
    }
  }

  @override
  void onAudioFocusGained() {
    player.setVolume(1.0);
  }

  @override
  void onAudioFocusLost() {
    onPause();
  }

  @override
  void onAudioFocusLostTransient() {
    onPause();
  }

  @override
  void onAudioFocusLostTransientCanDuck() {
    player.setVolume(0.5);
  }

  bool onSetRepeatMode(int mode) {
    player.repeatMode = AudioRepeatMode.values.firstWhere(
      (value) => value.index == mode,
    );
    return true;
  }

  MediaControl getPlayPauseControl() {
    return player.isPlaying ? pauseControl : playControl;
  }

  List<MediaControl> getControls() {
    return [
      skipToPreviousControl,
      getPlayPauseControl(),
      stopControl,
      skipToNextControl,
    ];
  }

  void onStateChange(MediaPlayerState state) {
    // Set state
    AudioServiceBackground.setState(
      controls: getControls(),
      basicState: toBasicState(state.state),
      position: state.position,
    );

    final durationChange =
        (_media != null && _media.duration != state.media.duration);

    // Update media item
    if (_media != state.media || durationChange) {
      AudioServiceBackground.setMediaItem(state.media);
      _media = state.media;
    }
  }

  BasicPlaybackState toBasicState(AudioPlaybackState state) {
    // Convert audio state to service state
    switch (state) {
      case AudioPlaybackState.completed:
        return BasicPlaybackState.stopped;
      case AudioPlaybackState.connecting:
        return BasicPlaybackState.connecting;
      case AudioPlaybackState.none:
        return BasicPlaybackState.none;
      case AudioPlaybackState.paused:
        return BasicPlaybackState.paused;
      case AudioPlaybackState.playing:
        return BasicPlaybackState.playing;
      case AudioPlaybackState.stopped:
        return BasicPlaybackState.stopped;
      default:
        return BasicPlaybackState.none;
    }
  }

  static AudioPlaybackState getAudioState(BasicPlaybackState state) {
    switch (state) {
      case BasicPlaybackState.stopped:
        return AudioPlaybackState.completed;
      case BasicPlaybackState.connecting:
        return AudioPlaybackState.connecting;
      case BasicPlaybackState.none:
        return AudioPlaybackState.none;
      case BasicPlaybackState.paused:
        return AudioPlaybackState.paused;
      case BasicPlaybackState.playing:
        return AudioPlaybackState.playing;
      case BasicPlaybackState.stopped:
        return AudioPlaybackState.stopped;
      default:
        return AudioPlaybackState.none;
    }
  }
}
