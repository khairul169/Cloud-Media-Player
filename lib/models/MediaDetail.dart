import 'package:audio_service/audio_service.dart';
import 'package:cmp/public/Utils.dart';
import 'package:cmp/services/ApiHelper.dart';

class MediaDetail {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int year;
  final String image;

  MediaDetail({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.year,
    this.image,
  });

  factory MediaDetail.fromJson(dynamic json) => MediaDetail(
        id: json['id'],
        title: json['title'],
        artist: json['artist'],
        album: json['album'],
        year: json['year'],
        image: json['image'],
      );

  MediaItem toMediaItem() => MediaItem(
        id: ApiHelper.getUrl('media/get/$id'),
        title: Utils.isEmpty(title) ? 'Playing...' : title,
        album: album,
        artist: Utils.isEmpty(artist) ? 'Unknown Artist' : artist,
        artUri: image,
      );
}
