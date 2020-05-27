import 'package:cmp/models/media.dart';
import 'package:cmp/services/media_player.dart';

class Playlist {
  final int id;
  final String title;
  final String description;
  final String subtitle;
  final int playTime;
  final List<Media> items;

  Playlist({
    this.id,
    this.title,
    this.description,
    this.subtitle,
    this.playTime,
    this.items,
  });

  factory Playlist.fromJson(dynamic json) => Playlist(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subtitle: json['subtitle'],
      playTime: json['play_time'],
      items: parseItems(json['items']));

  static List<Media> parseItems(items) {
    return List.from(items).map((item) => Media.fromJson(item)).toList();
  }

  List<MediaPlayerItem> toMediaQueue() {
    return items
        .where((e) => e.url != null || e.localPath != null)
        .map((e) => e.toPlayerItem())
        .toList();
  }

  Playlist copyWith({
    int id,
    String title,
    String description,
    String subtitle,
    int playTime,
    List<Media> items,
  }) {
    return Playlist(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subtitle: subtitle ?? this.subtitle,
      playTime: playTime ?? this.playTime,
      items: items ?? this.items,
    );
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
