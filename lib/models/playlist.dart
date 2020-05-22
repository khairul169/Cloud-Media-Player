import 'package:cmp/models/media.dart';
import 'package:cmp/models/media_player_item.dart';

class Playlist {
  final List<Media> items;

  Playlist({this.items});

  factory Playlist.fromMedia(Media item) => Playlist(items: [item]);

  factory Playlist.fromJson(dynamic json) {
    var itemList = List.from(json).map((item) => Media.fromJson(item)).toList();
    return Playlist(items: itemList);
  }

  List<MediaPlayerItem> toMediaQueue() {
    return items.map((e) => e.toPlayerItem()).toList();
  }
}
