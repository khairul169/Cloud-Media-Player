import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

void audioTaskEntry() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

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

class AudioPlayerTask extends BackgroundAudioTask {
  final player = AudioPlayer();
  final completer = Completer();

  bool isPlaying = false;

  static startService() {
    // Start audio service
    AudioService.start(
      backgroundTaskEntrypoint: audioTaskEntry,
      androidNotificationChannelName: 'Cloud Media Player',
      notificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
  }

  @override
  Future<void> onStart() async {
    isPlaying = false;
    await completer.future;
  }

  @override
  void onPlay() {
    if (isPlaying) return;

    player.play();
    isPlaying = true;
    updateState();
  }

  @override
  void onStop() async {
    if (!isPlaying) return;

    await player.stop();
    isPlaying = false;
    updateState();
  }

  @override
  void onPause() async {
    if (!isPlaying) return;

    await player.pause();
    isPlaying = false;
    updateState();
  }

  @override
  void onSkipToNext() {
    AudioServiceBackground.sendCustomEvent('next');
  }

  @override
  void onSkipToPrevious() {
    AudioServiceBackground.sendCustomEvent('prev');
  }

  @override
  void onPlayMediaItem(MediaItem media) async {
    if (isPlaying) {
      onStop();
    }

    await player.setUrl(media.id);
    AudioServiceBackground.setMediaItem(media);
    onPlay();
  }

  MediaControl getPlayPauseControl() {
    return isPlaying ? pauseControl : playControl;
  }

  List<MediaControl> getControls() {
    return [
      skipToPreviousControl,
      getPlayPauseControl(),
      stopControl,
      skipToNextControl,
    ];
  }

  void updateState() {
    AudioServiceBackground.setState(
      controls: getControls(),
      basicState:
          isPlaying ? BasicPlaybackState.playing : BasicPlaybackState.paused,
    );
  }
}
