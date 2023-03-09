import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'marker_examples.dart';

class MapController extends ChangeNotifier {
  final initialCameraPos = const CameraPosition(
    target: LatLng(-8.1166336, -79.0429696),
    zoom: 15,
  );

  final fetchedMarkers = customMarkers;

  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  MapController() {
    for (int i = 0; i < customMarkers.length; i++) {
      addMarker(customMarkers[i]);
    }
  }

  void addMarker(CustomMarker cMarker) {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final newMarker = Marker(
      markerId: markerId,
      position: cMarker.location,
      draggable: true,
      onTap: () => debugPrint("$markerId"),
    );

    _markers[markerId] = newMarker;
    notifyListeners();
  }

  void addExampleMarker() {
    addMarker(additionalCustom);
  }
}
