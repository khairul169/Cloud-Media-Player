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

  List<MediaItem> queue;
  bool isPlaying = false;
  int curIndex = -1;

  static startService() {
    // Start audio service
    AudioService.start(
      backgroundTaskEntrypoint: audioTaskEntry,
      androidNotificationChannelName: 'Cloud Media Player',
      notificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      enableQueue: true,
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
    skipIndex(1);
  }

  @override
  void onSkipToPrevious() {
    skipIndex(-1);
  }

  @override
  void onPlayMediaItem(MediaItem media) async {
    String url = media.extras['url'];
    if (url == null) return;

    if (isPlaying) {
      onStop();
    }

    await player.setUrl(url);
    AudioServiceBackground.setMediaItem(media);
    onPlay();
  }

  @override
  Future<void> onReplaceQueue(List<MediaItem> items) async {
    queue = items;
  }

  @override
  void onPlayFromMediaId(String mediaId) {
    try {
      var id = int.tryParse(mediaId, radix: 10);
      playMedia(id);
    } catch (error) {}
  }

  void playMedia(int id) {
    curIndex = (id < 0 ? 0 : (id >= queue.length ? queue.length - 1 : id));
    onPlayMediaItem(queue[curIndex]);
  }

  void skipIndex(int rel) {
    var newIndex = curIndex + rel;
    if (newIndex < 0) {
      newIndex = queue.length - 1;
    } else if (newIndex >= queue.length) {
      newIndex = 0;
    }
    playMedia(newIndex);
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
