import 'package:audio_service/audio_service.dart';
import 'package:cmp/public/Utils.dart';
import 'package:cmp/services/ApiHelper.dart';

class Media {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;

  Media({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.image,
  });

  factory Media.fromJson(dynamic json) => Media(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      year: json['year'],
      image: json['image']);

  MediaItem toMediaItem(int key) => MediaItem(
      id: key.toString(),
      title: Utils.isEmpty(title) ? 'Playing...' : title,
      album: album,
      artist: Utils.isEmpty(artist) ? 'Unknown Artist' : artist,
      artUri: image,
      extras: {'url': getUrl()});

  getUrl() {
    return ApiHelper.getUrl('media/get/$id');
  }
}
