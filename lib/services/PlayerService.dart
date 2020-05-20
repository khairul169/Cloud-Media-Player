import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/Media.dart';
import 'package:cmp/models/Playlist.dart';

enum PlayerRepeat { None, Single, All }

class PlayerService {
  static void play() => AudioService.play();
  static void pause() => AudioService.pause();
  static void stop() => AudioService.stop();
  static void next() => AudioService.skipToNext();
  static void prev() => AudioService.skipToPrevious();

  static void playMedia(Media media) {
    AudioService.playMediaItem(media.toMediaItem());
  }

  static void playIndex(int id) {
    AudioService.playFromMediaId(id.toString());
  }

  static void setPlayList(Playlist playlist, {int playId}) {
    var queue = playlist.toQueue();
    if (queue != AudioService.queue) AudioService.replaceQueue(queue);
    playIndex(playId ?? 0);
  }

  static void setRepeatMode(PlayerRepeat mode) {
    AudioService.customAction('setRepeatMode', mode.index);
  }
}
