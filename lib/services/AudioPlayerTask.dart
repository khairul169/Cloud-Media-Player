import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

enum AudioPlayerRepeat { None, Single, All }

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
  int curIndex = -1;
  AudioPlayerRepeat repeatMode = AudioPlayerRepeat.None;
  bool queueMode = false;

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
    // Listen to state change
    var playCompleteListener = player.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) => onPlaybackComplete());
    var positionListener = player.getPositionStream().listen((data) {
      var position = data?.inMilliseconds ?? 0;
      updateState(position: position);
    });

    // Wait for free
    await completer.future;
    playCompleteListener.cancel();
    positionListener.cancel();
  }

  @override
  void onPlay() async {
    if (isWaiting()) return;

    await player.play();
    updateState();
  }

  @override
  void onStop() async {
    if (!isPlaying()) return;

    await player.stop();
    updateState();
  }

  @override
  void onPause() async {
    if (!isPlaying()) return;

    await player.pause();
    updateState();
  }

  @override
  void onSkipToNext() {
    if (!queueMode || queue == null) return;
    skipIndex(1);
  }

  @override
  void onSkipToPrevious() {
    if (!queueMode || queue == null) return;
    skipIndex(-1);
  }

  @override
  void onPlayMediaItem(MediaItem media) async {
    if (isConnecting()) return;

    queueMode = false;
    playMediaItem(media);
  }

  @override
  Future<void> onReplaceQueue(List<MediaItem> items) async {
    if (queue != items) {
      queue = items;
    }
  }

  @override
  void onPlayFromMediaId(String mediaId) {
    try {
      var id = int.tryParse(mediaId, radix: 10);
      playMediaId(id);
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

  @override
  void onAudioFocusGained() {
    player.setVolume(1.0);
    //if (isPaused()) onPlay();
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

  void onPlaybackComplete() {
    if (!queueMode || queue == null) return;

    // Repeat media
    if (repeatMode == AudioPlayerRepeat.Single) {
      playMediaId(curIndex);
    } else if (repeatMode == AudioPlayerRepeat.All ||
        curIndex < queue.length - 1) {
      skipIndex(1);
    }
  }

  void playMediaItem(MediaItem media) async {
    if (isConnecting()) return;

    String url = media.extras['url'];
    if (url == null) return;

    if (isPlaying()) {
      onStop();
    }

    // Notify media change
    AudioServiceBackground.setMediaItem(media);

    try {
      var duration = await player.setUrl(url);

      // Update duration
      AudioServiceBackground.setMediaItem(
        media.copyWith(duration: duration?.inMilliseconds ?? 0),
      );

      onPlay();
    } catch (error) {
      print(error);
    }
  }

  void playMediaId(int id) {
    if (isConnecting()) return;

    curIndex = (id < 0 ? 0 : (id >= queue.length ? queue.length - 1 : id));
    queueMode = true;
    playMediaItem(queue[curIndex]);
  }

  void skipIndex(int rel) {
    var newIndex = curIndex + rel;
    if (newIndex < 0) {
      newIndex = queue.length - 1;
    } else if (newIndex >= queue.length) {
      newIndex = 0;
    }
    playMediaId(newIndex);
  }

  void setRepeatMode(AudioPlayerRepeat mode) {
    repeatMode = mode;
  }

  MediaControl getPlayPauseControl() {
    return isPlaying() ? pauseControl : playControl;
  }

  List<MediaControl> getControls() {
    return [
      skipToPreviousControl,
      getPlayPauseControl(),
      stopControl,
      skipToNextControl,
    ];
  }

  bool isPlaying() => player.playbackState == AudioPlaybackState.playing;

  bool isPaused() => player.playbackState == AudioPlaybackState.paused;

  bool isWaiting() =>
      player.playbackState == AudioPlaybackState.none ||
      player.playbackState == AudioPlaybackState.connecting;

  bool isConnecting() => player.playbackState == AudioPlaybackState.connecting;

  void updateState({int position}) {
    // Playback position
    final pbPos = player.playbackEvent.position?.inMilliseconds;

    // Set state
    AudioServiceBackground.setState(
      controls: getControls(),
      basicState: toBasicState(),
      position: position == null ? pbPos : position,
    );
  }

  BasicPlaybackState toBasicState() {
    // Convert audio state to service state
    switch (player.playbackState) {
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
}
