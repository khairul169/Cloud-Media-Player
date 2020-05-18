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
}
