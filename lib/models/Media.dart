import 'package:audio_service/audio_service.dart';
import 'package:cmp/public/Utils.dart';

class Media {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;

  String url;
  bool local;

  Media({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.image,
    this.url,
    this.local,
  });

  factory Media.fromJson(dynamic json) => Media(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      year: json['year'],
      image: json['image'],
      url: json['url']);

  factory Media.fromMediaItem(MediaItem media) => Media(
      title: media.title,
      album: media.album,
      artist: media.artist,
      image: media.artUri,
      url: media.extras['url'],
      local: media.extras['local']);

  MediaItem toMediaItem({String key, String albumName}) => MediaItem(
      id: key,
      title: Utils.isEmpty(title) ? 'Playing...' : title,
      album: albumName ?? album ?? '',
      artist: Utils.isEmpty(artist) ? 'Unknown' : artist,
      artUri: image,
      extras: {'url': url, 'local': local});

  void setLocalPath(String path) {
    url = path;
    local = true;
  }
}

class MediaList {
  final List<Media> items;

  MediaList({this.items});

  factory MediaList.fromJson(dynamic json) {
    var itemList = List.from(json).map((item) => Media.fromJson(item)).toList();
    return MediaList(items: itemList);
  }
}
