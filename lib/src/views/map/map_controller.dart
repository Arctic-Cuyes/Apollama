import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_hub/src/services/custom_markers_service.dart';
import '../../services/gps_service.dart';
import 'marker_examples.dart';

class MapController extends ChangeNotifier {
  late final BitmapDescriptor avisoMarker;
  late final BitmapDescriptor ayudaMarker;
  late final BitmapDescriptor eventoMarker;
  late final BitmapDescriptor saludMarker;
  late final BitmapDescriptor petMarker;

  late CameraPosition _initialCameraPos;
  late final CustomMarkerIcons _markersService;
  late final GpsService _gpsService;

  late final List<CustomMarker> fetchedMarkers;
  final Map<MarkerId, Marker> _markers = {};

  MapController() {
    _markersService = CustomMarkerIcons();
    _gpsService = GpsService();
    fetchedMarkers = customMarkers;
    loadMarkers();
  }

  Set<Marker> get markers => _markers.values.toSet();

  Future<CameraPosition> get initialCameraPos async {
    Position? initialPosition = await _gpsService.determinePosition();
    if (initialPosition != null) {
      _initialCameraPos = CameraPosition(
          target: LatLng(initialPosition.latitude, initialPosition.longitude),
          zoom: 15);
    } else {
      initialPosition = await _gpsService.determineLastPosition();
      if (initialPosition != null) {
        _initialCameraPos = CameraPosition(
            target: LatLng(initialPosition.latitude, initialPosition.longitude),
            zoom: 15);
      } else {
        _initialCameraPos =
            const CameraPosition(target: LatLng(0, 0), zoom: 0.0);
      }
    }
    return _initialCameraPos;
  }

  void loadMarkers() async {
    avisoMarker = await _markersService.avisoMarker;
    ayudaMarker = await _markersService.ayudaMarker;
    eventoMarker = await _markersService.eventoMarker;
    petMarker = await _markersService.petMarker;
    saludMarker = await _markersService.saludMarker;

    for (CustomMarker item in customMarkers) {
      addMarker(item);
    }
  }

  BitmapDescriptor assignIcon(int categoria) {
    //TODO: proper logic to assign icon according to category/tag marker
    late final BitmapDescriptor icon;
    switch (categoria) {
      case 1:
        icon = avisoMarker;
        break;
      case 2:
        icon = ayudaMarker;
        break;
      case 3:
        icon = eventoMarker;
        break;
      case 4:
        icon = petMarker;
        break;
      case 5:
        icon = saludMarker;
        break;
    }

    return icon;
  }

  void addMarker(CustomMarker cMarker) async {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);
    final icon = assignIcon(cMarker.category);
    final newMarker = Marker(
      markerId: markerId,
      position: cMarker.location,
      icon: icon,
      // draggable: true,
      onTap: () => debugPrint("$markerId"),
    );

    _markers[markerId] = newMarker;
    notifyListeners();
  }

  void addExampleMarker() {
    addMarker(additionalCustom);
  }
}
