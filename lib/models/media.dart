import 'package:cmp/services/media_player.dart';

class Media {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;
  final int duration;
  final String url;

  final bool waiting;
  final String localPath;

  Media({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.image,
    this.duration,
    this.url,
    this.waiting = false,
    this.localPath,
  });

  factory Media.fromJson(dynamic json) {
    return Media(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      year: json['year'],
      image: json['image'],
      duration: json['duration'],
      url: json['url'],
    );
  }

  Media copyWith({
    int id,
    String title,
    String artist,
    String album,
    int year,
    String image,
    int duration,
    String url,
    bool waiting,
    String localPath,
  }) {
    var path = localPath;
    if (path == null) {
      path = this.localPath;
    } else if (path == 'null') {
      path = null;
    }

    return Media(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      year: year ?? this.year,
      image: image ?? this.image,
      url: url ?? this.url,
      waiting: waiting ?? this.waiting,
      localPath: path,
    );
  }

  MediaPlayerItem toPlayerItem() {
    return MediaPlayerItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      image: image,
      duration: 0,
      url: localPath ?? url,
      local: localPath != null,
    );
  }
}
