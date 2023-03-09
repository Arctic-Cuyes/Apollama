import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/gps_service.dart';
import 'marker_examples.dart';

class MapController extends ChangeNotifier {
  final _gpsService = GpsService();
  late CameraPosition _initialCameraPos;

  Future<CameraPosition> get initialCameraPos async {
    Position? initialPosition = await _gpsService.determinePosition();
    if (initialPosition != null) {
      _initialCameraPos = CameraPosition(
          target: LatLng(initialPosition.latitude, initialPosition.longitude),
          zoom: 14.5);
    } else {
      initialPosition = await _gpsService.determineLastPosition();
      if (initialPosition != null) {
        _initialCameraPos = CameraPosition(
            target: LatLng(initialPosition.latitude, initialPosition.longitude),
            zoom: 14.5);
      } else {
        _initialCameraPos =
            const CameraPosition(target: LatLng(0, 0), zoom: 0.0);
      }
    }

    return _initialCameraPos;
  }

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
