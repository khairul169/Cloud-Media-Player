import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

enum AudioRepeatMode { None, Single, All }

class MediaPlayerState {
  AudioPlaybackState state;
  int position;
  MediaItem media;

  MediaPlayerState({this.state, this.position, this.media});

  copyWith({
    AudioPlaybackState state,
    int position,
    MediaItem media,
  }) {
    return MediaPlayerState(
      state: state ?? this.state,
      position: position ?? this.position,
      media: media ?? this.media,
    );
  }
}

class MediaPlayer {
  final player = AudioPlayer();

  MediaPlayerState _state;
  List<MediaItem> queue;
  int curIndex = -1;
  AudioRepeatMode repeatMode = AudioRepeatMode.None;
  bool queueMode = false;
  StreamController<MediaPlayerState> stateEvent;

  MediaPlayer() {
    _state = MediaPlayerState();
    stateEvent = StreamController();
  }

  Function init() {
    // Listen to state change
    var playCompleteListener = player.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) => onPlaybackComplete());

    // Position change
    var positionListener = player.getPositionStream().listen((data) {
      var position = data?.inMilliseconds ?? 0;
      _setState(position: position);
    });

    return () {
      stateEvent.close();
      playCompleteListener.cancel();
      positionListener.cancel();
    };
  }

  void play() async {
    if (isBusy || isPlaying) return;

    await player.play();
    _setState();
  }

  void stop() async {
    if (!isPlaying) return;

    await player.stop();
    _setState();
  }

  void pause() async {
    if (!isPlaying) return;

    await player.pause();
    _setState();
  }

  void skipToNext() {
    if (!queueMode || queue == null) return;
    skipIndex(1);
  }

  void skipToPrevious() {
    if (!queueMode || queue == null) return;
    skipIndex(-1);
  }

  void setQueue(List<MediaItem> items) {
    if (queue != items) {
      queue = items;
    }
  }

  Future<int> _playMedia(MediaItem media) async {
    String url = media.extras['url'];
    bool local = media.extras['local'] ?? false;

    if (url == null) return 0;
    if (isPlaying) stop();

    // Update state
    _setState(media: media);

    // Set url / path
    var duration =
        !local ? await player.setUrl(url) : await player.setFilePath(url);

    // Workaround for web build
    if (kIsWeb) await Future.delayed(Duration(milliseconds: 500));

    // Play media
    play();

    // Update media duration
    _setState(media: media.copyWith(duration: duration.inMilliseconds));

    return duration.inMilliseconds;
  }

  Future<int> playMediaItem(MediaItem media) async {
    if (isBusy) return 0;

    queueMode = false;
    return await _playMedia(media);
  }

  Future<int> playMediaId(int id) async {
    if (isBusy) return 0;

    curIndex = (id < 0 ? 0 : (id >= queue.length ? queue.length - 1 : id));
    queueMode = true;

    return await _playMedia(queue[curIndex]);
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

  void setVolume(double volume) => player.setVolume(volume);

  void onPlaybackComplete() {
    if (!queueMode || queue == null) return;

    // Repeat media
    if (repeatMode == AudioRepeatMode.Single) {
      playMediaId(curIndex);
    } else if (repeatMode == AudioRepeatMode.All ||
        curIndex < queue.length - 1) {
      skipIndex(1);
    }
  }

  void _setState({
    AudioPlaybackState state,
    int position,
    MediaItem media,
  }) {
    // Playback position
    final iState = player.playbackState;
    final iPosition = player.playbackEvent.position?.inMilliseconds;
    final iMedia = _state.media;

    _state = _state.copyWith(
      state: state ?? iState,
      position: position ?? iPosition,
      media: media ?? iMedia,
    );

    stateEvent.add(_state);
  }

  MediaPlayerState get state => _state;

  bool get isPlaying => player.playbackState == AudioPlaybackState.playing;

  bool get isPaused => player.playbackState == AudioPlaybackState.paused;

  bool get isBusy => player.playbackState == AudioPlaybackState.connecting;
}
