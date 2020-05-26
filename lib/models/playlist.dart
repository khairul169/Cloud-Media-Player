import 'package:cmp/models/media.dart';
import 'package:cmp/services/media_player.dart';

class Playlist {
  final List<Media> items;

  Playlist({this.items});

  factory Playlist.fromMedia(Media item) => Playlist(items: [item]);

  factory Playlist.fromJson(dynamic json) {
    var itemList = List.from(json).map((item) => Media.fromJson(item)).toList();
    return Playlist(items: itemList);
  }

  List<MediaPlayerItem> toMediaQueue() {
    return items
        .where((e) => e.url != null || e.localPath != null)
        .map((e) => e.toPlayerItem())
        .toList();
  }

  Playlist copyWith({List<Media> items}) {
    return Playlist(items: items ?? this.items);
  }

  Playlist add(Media media) {
    var newItems = List<Media>.from(items);
    newItems.add(media);
    return copyWith(items: newItems);
  }

  Playlist remove(int index) {
    var newItems = List<Media>.from(items);
    newItems.removeAt(index);
    return copyWith(items: newItems);
  }
}
