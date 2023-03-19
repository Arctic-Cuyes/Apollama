import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final geo = Geoflutterfire();

class CustomMarker {
  CustomMarker({
    required this.id,
    required this.title,
    required this.address,
    required this.location,
    required this.category,
  });

  dynamic id;
  final String title;
  final String address;
  final GeoFirePoint location;
  final int category;
}

List _locations = [
  geo.point(latitude: -8.128258, longitude: -79.0341047),
  geo.point(latitude: -8.130043, longitude: -79.043245),
  geo.point(latitude: -8.132877, longitude: -79.040018),
  geo.point(latitude: -8.132070, longitude: -79.038752),
  geo.point(latitude: -8.131847, longitude: -79.037786),
];

final customMarkers = [
  CustomMarker(
    id: 1,
    title: 'Marcos',
    address: "aaa",
    location: _locations[0],
    category: 1,
  ),
  CustomMarker(
    id: 2,
    title: 'Juan',
    address: "bbb",
    location: _locations[1],
    category: 2,
  ),
  CustomMarker(
    id: 3,
    title: 'Ana',
    address: "ccc",
    location: _locations[2],
    category: 3,
  ),
  CustomMarker(
    id: 4,
    title: 'Martha',
    address: "ddd",
    location: _locations[3],
    category: 4,
  ),
  CustomMarker(
    id: 5,
    title: 'Leo',
    address: "eee",
    location: _locations[4],
    category: 5,
  ),
];

Future<List<CustomMarker>> asyncCustomMarkers() {
  return Future.delayed(
    const Duration(seconds: 3),
    () => customMarkers,
  );
}

final _additionalCustom = CustomMarker(
  id: 0,
  title: 'Leo',
  address: "eee",
  location: _locations[4],
  category: 5,
);

Future<CustomMarker> asyncAdditionalCustom() {
  return Future.delayed(
    const Duration(seconds: 2),
    () => _additionalCustom,
  );
}
