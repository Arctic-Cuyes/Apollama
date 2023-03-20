import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_hub/src/services/Map/custom_markers_service.dart';
import 'package:zona_hub/src/views/map/marker_bottom_sheet.dart';
import '../../services/Map/gps_service.dart';
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

  late bool isDisposed;

  MapController(BuildContext context) {
    _markersService = CustomMarkerIcons();
    _gpsService = GpsService();
    isDisposed = false;
    loadMarkers(context);
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

  void loadMarkers(BuildContext context) async {
    fetchedMarkers = await asyncCustomMarkers();
    avisoMarker = await _markersService.avisoMarker;
    ayudaMarker = await _markersService.ayudaMarker;
    eventoMarker = await _markersService.eventoMarker;
    petMarker = await _markersService.petMarker;
    saludMarker = await _markersService.saludMarker;

    for (CustomMarker item in fetchedMarkers) {
      // ignore: use_build_context_synchronously
      addMarker(item, context);
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

  void addMarker(CustomMarker cMarker, BuildContext context) async {
    final id = _markers.length;
    cMarker.id = id;
    final markerId = MarkerId(id.toString());
    final icon = assignIcon(cMarker.category);
    final newMarker = Marker(
      markerId: markerId,
      position: cMarker.location,
      icon: icon,
      draggable: true,
      onTap: () {
        debugPrint(markerId.toString());
        showMarkerBottomSheet(context, cMarker);
      },
    );

    _markers[markerId] = newMarker;
    notifyListeners();
  }

  void addExampleMarker(BuildContext context) async {
    CustomMarker additional = await asyncAdditionalCustom();
    // ignore: use_build_context_synchronously
    addMarker(additional, context);
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isDisposed = true;
    super.dispose();
  }
}
