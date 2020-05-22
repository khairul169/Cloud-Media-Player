import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';
import 'package:cmp/services/MediaBackground.dart';
import 'package:cmp/services/MediaPlayer.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class MediaService {
  static MediaPlayer _player;
  static Function _disposeFn;

  static Future<void> init() async {
    if (kIsWeb) {
      _player = MediaPlayer();
      _disposeFn = _player.init();
    } else {
      await MediaBackground.start();
    }
  }

  static void play() {
    return (_player != null) ? _player.play() : AudioService.play();
  }

  static void pause() {
    return (_player != null) ? _player.pause() : AudioService.pause();
  }

  static void stop() {
    return (_player != null) ? _player.stop() : AudioService.stop();
  }

  static void next() {
    return (_player != null) ? _player.skipToNext() : AudioService.skipToNext();
  }

  static void prev() {
    return (_player != null)
        ? _player.skipToPrevious()
        : AudioService.skipToPrevious();
  }

  static Stream<MediaPlayerState> get stateEvent {
    if (_player != null) return _player.stateEvent;

    // Combine audio service streams
    return CombineLatestStream.combine2(
      AudioService.currentMediaItemStream,
      AudioService.playbackStateStream,
      (MediaItem media, PlaybackState playback) => MediaPlayerState(
        media: media,
        state: MediaBackground.getAudioState(playback.basicState),
        position: playback.position,
      ),
    );
  }

  static bool get isPlaying {
    return (_player != null)
        ? _player.isPlaying
        : AudioService.playbackState.basicState == BasicPlaybackState.playing;
  }

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

  static void setPlaylist(Playlist playlist) {
    var queue = playlist.toQueue();
    if (_player != null) {
      _player.setQueue(queue);
    } else {
      AudioService.replaceQueue(queue);
    }
  }

  static Playlist get playlist {
    var queue = (_player != null) ? _player.queue : AudioService.queue;
    var items = List.from(queue).map((e) => Media.fromMediaItem(e)).toList();
    return Playlist(items: items);
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
