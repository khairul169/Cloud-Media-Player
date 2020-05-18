import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/Media.dart';

class Playlist {
  final List<Media> items;

  Playlist(this.items);

  List<MediaItem> toQueue() {
    return items.map((item) => item.toMediaItem());
  }
}
