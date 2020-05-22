import 'package:audio_service/audio_service.dart';
import 'package:cmp/public/utils.dart';

class MediaPlayerItem {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String image;
  final int duration;
  final String url;
  final bool local;

  MediaPlayerItem({
    this.id,
    this.title,
    this.artist,
    this.album,
    this.image,
    this.duration,
    this.url,
    this.local,
  });

  factory MediaPlayerItem.fromMediaItem(MediaItem mediaItem) {
    if (mediaItem == null) return null;
    return MediaPlayerItem(
      id: int.parse(mediaItem.id),
      title: mediaItem.title,
      artist: mediaItem.artist,
      album: mediaItem.album,
      image: mediaItem.artUri,
      duration: mediaItem.duration,
      url: mediaItem.extras['url'],
      local: mediaItem.extras['local'],
    );
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id.toString(),
      title: title ?? '',
      artist: Utils.isEmpty(artist) ? 'Unknown' : artist,
      album: album ?? '',
      artUri: image ?? '',
      duration: duration ?? 0,
      extras: {
        'url': url,
        'local': local,
      },
    );
  }

  MediaPlayerItem copyWith({
    int id,
    String title,
    String artist,
    String album,
    String image,
    int duration,
    String url,
    bool local,
  }) {
    return MediaPlayerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      url: url ?? this.url,
      local: local ?? this.local,
    );
  }

  bool equals(MediaItem mediaItem) {
    return (mediaItem != null &&
        id == int.parse(mediaItem.id) &&
        title == mediaItem.title &&
        artist == mediaItem.artist &&
        album == mediaItem.album &&
        image == mediaItem.artUri &&
        duration == mediaItem.duration);
  }
}
