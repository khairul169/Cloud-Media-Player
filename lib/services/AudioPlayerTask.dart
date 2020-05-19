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

enum AudioPlayerRepeat { None, Single, All }

class AudioPlayerTask extends BackgroundAudioTask {
  final player = AudioPlayer();
  final completer = Completer();

  List<MediaItem> queue;
  bool isPlaying = false;
  int curIndex = -1;
  AudioPlayerRepeat repeatMode = AudioPlayerRepeat.None;

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

    // Listen to state change
    var playCompleteListener = player.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) => onPlaybackComplete());
    var positionListener = player.getPositionStream().listen((data) {
      var position = data?.inSeconds ?? 0;
      updateState(position: position);
    });

    // Wait for free
    await completer.future;
    playCompleteListener.cancel();
    positionListener.cancel();
  }

  @override
  void onPlay() async {
    if (isPlaying) return;

    await player.play();
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

  void onPlaybackComplete() {
    // Stop player
    onStop();

    // Repeat media
    if (repeatMode == AudioPlayerRepeat.Single) {
      playMedia(curIndex);
    } else if (repeatMode == AudioPlayerRepeat.All ||
        curIndex < queue.length - 1) {
      skipIndex(1);
    }
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

    var duration = await player.setUrl(url);
    var newMedia = media.copyWith(duration: duration?.inSeconds ?? 0);

    AudioServiceBackground.setMediaItem(newMedia);
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

  @override
  Future onCustomAction(String name, arguments) async {
    switch (name) {
      case 'setRepeatMode':
        var mode = AudioPlayerRepeat.values
            .firstWhere((value) => value.index == arguments);
        setRepeatMode(mode);
        break;
      default:
        break;
    }
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

  void setRepeatMode(AudioPlayerRepeat mode) {
    repeatMode = mode;
  }

  MediaControl getPlayPauseControl() {
    return isPlaying ? pauseControl : playControl;
  }

  List<MediaControl> getControls() {
    return [
      skipToPreviousControl,
      getPlayPauseControl(),
      skipToNextControl,
    ];
  }

  void updateState({int position}) {
    // Playback position
    final pbPos = player.playbackEvent.position?.inSeconds;

    // Set state
    AudioServiceBackground.setState(
      controls: getControls(),
      basicState:
          isPlaying ? BasicPlaybackState.playing : BasicPlaybackState.paused,
      position: position == null ? pbPos : position,
    );
  }
}
