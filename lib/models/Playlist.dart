import 'package:audio_service/audio_service.dart';
import 'package:cmp/models/Media.dart';

class Playlist {
  final List<Media> items;

  Playlist({this.items});

  factory Playlist.fromMedia(Media item) => Playlist(items: [item]);

  factory Playlist.fromMediaList(MediaList list) => Playlist(items: list.items);

  factory Playlist.fromJson(dynamic json) {
    var itemList = List.from(json).map((item) => Media.fromJson(item)).toList();
    return Playlist(items: itemList);
  }

  addMedia(Media item) {
    items.add(item);
  }

  removeMedia(Media item) {
    items.remove(item);
  }

  List<MediaItem> toQueue() {
    return items.asMap().entries.map((entry) {
      var key = entry.key;
      return entry.value.toMediaItem(key: key.toString());
    }).toList();
  }
}
