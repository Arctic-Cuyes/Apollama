import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker {
  CustomMarker({
    required this.id,
    required this.title,
    required this.address,
    required this.location,
    required this.category,
  });

  int id;
  final String title;
  final String address;
  final LatLng location;
  final int category;
}

const _locations = [
  LatLng(-8.128258, -79.0341047),
  LatLng(-8.130043, -79.043245),
  LatLng(-8.132877, -79.040018),
  LatLng(-8.132070, -79.038752),
  LatLng(-8.131847, -79.037786),
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

final additionalCustom = CustomMarker(
  id: 0,
  title: 'Leo',
  address: "eee",
  location: _locations[4],
  category: 5,
);
