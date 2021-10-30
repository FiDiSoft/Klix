class ImgFields {
  static final List<String> imgCol = [
    id,
    img,
    longitude,
    latitude,
    desc,
    timeStamps
  ];

  static const String id = '_id';
  static const String img = 'img';
  static const String longitude = 'longitude';
  static const String latitude = 'latitude';
  static const String desc = 'desc';
  static const String timeStamps = 'time_stamps';
}

class Img {
  final int? id;
  final String img;
  final String longitude;
  final String latitude;
  final String desc;
  final DateTime timeStamps;

  Img({
    this.id,
    required this.img,
    required this.longitude,
    required this.latitude,
    required this.desc,
    required this.timeStamps,
  });

  Img copy({
    int? id,
    String? img,
    String? longitude,
    String? latitude,
    String? desc,
    DateTime? timeStamps,
  }) =>
      Img(
        id: id ?? this.id,
        img: img ?? this.img,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        desc: desc ?? this.desc,
        timeStamps: timeStamps ?? this.timeStamps,
      );

  static Img fromJson(Map<String, dynamic> json) {
    return Img(
      id: json[ImgFields.id] as int?,
      img: json[ImgFields.img] as String,
      longitude: json[ImgFields.longitude] as String,
      latitude: json[ImgFields.latitude] as String,
      desc: json[ImgFields.desc] as String,
      timeStamps: DateTime.parse(json[ImgFields.timeStamps] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      ImgFields.id: id,
      ImgFields.img: img,
      ImgFields.longitude: longitude,
      ImgFields.latitude: latitude,
      ImgFields.desc: desc,
      ImgFields.timeStamps: timeStamps.toIso8601String(),
    };
  }
}
