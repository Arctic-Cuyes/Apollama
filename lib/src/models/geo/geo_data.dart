import 'package:cloud_firestore/cloud_firestore.dart';

class GeoData {
  String geohash;
  GeoPoint geopoint;

  GeoData({required this.geohash, required this.geopoint});

  GeoData.fromJson(Map<String, dynamic> json)
      : geohash = json['geohash'] as String,
        geopoint = json['geopoint'] as GeoPoint;

  Map<String, dynamic> toJson() => {
        'geohash': geohash,
        'geopoint': geopoint,
      };
}
