import 'package:cmp/models/media_player_item.dart';

class Media {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;
  final int duration;
  final String url;
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
    this.localPath,
  });

  factory Media.fromJson(dynamic json) => Media(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      year: json['year'],
      image: json['image'],
      url: json['url']);

  bool get local => (localPath != null);

  Media withLocalPath(String path) => Media(
      id: id,
      title: title,
      artist: artist,
      album: album,
      year: year,
      image: image,
      url: url,
      localPath: path);

  MediaPlayerItem toPlayerItem() => MediaPlayerItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      image: image,
      duration: 0,
      url: localPath ?? url,
      local: localPath != null);
}
