class Masjid {
  final String id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final double latitude;
  final double longitude;
  final double distanceKm;

  const Masjid({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'nameEn': nameEn,
    'nameAr': nameAr,
    'lat': latitude,
    'lon': longitude,
    'distanceKm': distanceKm,
  };

  factory Masjid.fromJson(Map<String, dynamic> json) => Masjid(
    id: json['id'] as String,
    name: json['name'] as String,
    nameEn: json['nameEn'] as String?,
    nameAr: json['nameAr'] as String?,
    latitude: (json['lat'] as num).toDouble(),
    longitude: (json['lon'] as num).toDouble(),
    distanceKm: (json['distanceKm'] as num).toDouble(),
  );
}
