class ImgFields {
  static final List<String> imgCol = [id, img, longitude, latitude];

  static const String id = 'id';
  static const String img = 'img';
  static const String longitude = 'longitude';
  static const String latitude = 'latitude';
}

class Img {
  final int? id;
  final String img;
  final String longitude;
  final String latitude;

  Img(
      {this.id,
      required this.img,
      required this.longitude,
      required this.latitude});

  Img copy({
    int? id,
    String? img,
    String? longtitude,
    String? latitude,
  }) =>
      Img(
        id: id ?? this.id,
        img: img ?? this.img,
        longitude: longtitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );

  static Img fromJson(Map<String, dynamic> json) {
    return Img(
      id: json['id'] as int?,
      img: json['image'] as String,
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'image': img,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
