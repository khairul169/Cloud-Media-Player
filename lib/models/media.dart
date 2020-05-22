import 'package:cmp/models/media_player_item.dart';

class Media {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;
  final String url;
  final bool local;

  Media({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.image,
    this.url,
    this.local = false,
  });

  factory Media.fromJson(dynamic json) => Media(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      year: json['year'],
      image: json['image'],
      url: json['url']);

  Media withLocalPath(String path) => Media(
      id: id,
      title: title,
      artist: artist,
      album: album,
      year: year,
      image: image,
      url: path,
      local: true);

  MediaPlayerItem toPlayerItem() => MediaPlayerItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      image: image,
      duration: 0,
      url: url,
      local: local);
}
