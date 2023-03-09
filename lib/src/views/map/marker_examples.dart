import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker {
  const CustomMarker({
    required this.title,
    required this.address,
    required this.location,
  });

  final String title;
  final String address;
  final LatLng location;
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
    title: 'Marcos',
    address: "aaa",
    location: _locations[0],
  ),
  CustomMarker(
    title: 'Juan',
    address: "bbb",
    location: _locations[1],
  ),
  CustomMarker(
    title: 'Ana',
    address: "ccc",
    location: _locations[2],
  ),
  CustomMarker(
    title: 'Martha',
    address: "ddd",
    location: _locations[3],
  ),
  // CustomMarker(
  //   title: 'Leo',
  //   address: "eee",
  //   location: _locations[4],
  // ),
];

final additionalCustom = CustomMarker(
  title: 'Leo',
  address: "eee",
  location: _locations[4],
);
