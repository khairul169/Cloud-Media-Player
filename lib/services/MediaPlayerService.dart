import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/services/BackgroundAudioService.dart';
import 'package:cmp/services/MediaPlayer.dart';
import 'package:flutter/foundation.dart';

class MediaPlayerService {
  static MediaPlayer _player;
  static Function _disposeFn;

  static Future<void> init() async {
    if (kIsWeb) {
      _player = MediaPlayer();
      _disposeFn = _player.init();
    } else {
      await BackgroundAudioService.start();
    }
  }

  static void play() {
    return _player != null ? _player.play() : AudioService.play();
  }

  static void pause() {
    return _player != null ? _player.pause() : AudioService.pause();
  }

  static void stop() {
    return _player != null ? _player.stop() : AudioService.stop();
  }

  static void next() {
    return _player != null ? _player.skipToNext() : AudioService.skipToNext();
  }

  static void prev() {
    return _player != null
        ? _player.skipToPrevious()
        : AudioService.skipToPrevious();
  }

  static Stream<MediaPlayerState> get stateStream => _player.stateEvent.stream;

  static void playMedia(Media media) {
    if (_player != null) {
      _player.playMediaItem(media.toMediaItem());
    } else {
      AudioService.playMediaItem(media.toMediaItem());
    }
  }

  static void playIndex(int id) {
    if (_player != null) {
      _player.playMediaId(id);
    } else {
      AudioService.playFromMediaId(id.toString());
    }
  }

  static void setPlayList(Playlist playlist, {int playId}) {
    var queue = playlist.toQueue();
    if (_player != null) {
      _player.setQueue(queue);
    } else {
      AudioService.replaceQueue(queue);
    }
    playIndex(playId ?? 0);
  }

  static void setRepeatMode(AudioRepeatMode mode) {
    if (_player != null) {
      _player.repeatMode = mode;
    } else {
      AudioService.customAction('setRepeatMode', mode.index);
    }
  }

  static void dispose() {
    if (_disposeFn != null) _disposeFn();
  }
}
