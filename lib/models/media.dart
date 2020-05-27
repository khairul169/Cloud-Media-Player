import 'package:cmp/public/config.dart';
import 'package:cmp/services/media_player.dart';

class Media {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;
  final double duration;
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
    // Urls
    var url = Config.API_URL + 'media/get/' + json['media_fname'];
    var image =
        Config.API_URL + 'media/cover/' + (json['cover_fname'] ?? 'default');

    return Media(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      year: json['year'],
      duration: json['duration'],
      url: url,
      image: image,
    );
  }

  Media copyWith({
    int id,
    String title,
    String artist,
    String album,
    int year,
    String image,
    double duration,
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
      duration: duration ?? this.duration,
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
