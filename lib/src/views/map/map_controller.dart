// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_hub/src/services/custom_markers_service.dart';
import 'package:zona_hub/src/services/lazy_markers_service.dart';
import 'package:zona_hub/src/views/map/marker_bottom_sheet.dart';
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
  late final StreamSubscription _markersSubscription;
  late final StreamController<CameraPosition> _cameraPosController;

  late final List fetchedMarkers;
  final Map<MarkerId, Marker> _markers = {};

  late bool isDisposed;
  late final Geoflutterfire geo;

  MapController(BuildContext context) {
    _markersService = CustomMarkerIcons();
    _gpsService = GpsService();
    isDisposed = false;
    _cameraPosController = StreamController();
    geo = Geoflutterfire();
    fetchedMarkers = [];
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
    addNewCameraPos(_initialCameraPos);
    return _initialCameraPos;
  }

  void loadMarkers(BuildContext context) async {
    avisoMarker = await _markersService.avisoMarker;
    ayudaMarker = await _markersService.ayudaMarker;
    eventoMarker = await _markersService.eventoMarker;
    petMarker = await _markersService.petMarker;
    saludMarker = await _markersService.saludMarker;

    _markersSubscription = _markersListener(context);
  }

  BitmapDescriptor assignIcon(int categoria) {
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

  void addMarker(CustomMarker cMarker, BuildContext context) {
    final id = cMarker.id;
    final markerId = MarkerId(id.toString());
    final icon = assignIcon(cMarker.category);
    final newMarker = Marker(
      markerId: markerId,
      position: LatLng(cMarker.location.latitude, cMarker.location.longitude),
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

  // void addExampleMarker(BuildContext context) async {
  //   List additional = customMarkers;
  //   for (CustomMarker item in additional) {
  //     CollectionReference exampleMarkers =
  //         FirebaseFirestore.instance.collection('example_markers');
  //     await exampleMarkers.add({
  //       'location': item.location.data,
  //       'desc': item.address,
  //       'category': item.category,
  //       'title': item.title
  //     });
  //   }
  //   debugPrint("Subida de nuevos archivos finalizado");
  //   addMarker(additional, context);
  // }
// Future<StreamSubscription<List<DocumentSnapshot>>>
  StreamSubscription<CameraPosition> _markersListener(BuildContext context) {
    return _cameraPosController.stream.listen((cameraPos) {
      getStreamNearMarkers(cameraPos)
          .listen((List<DocumentSnapshot> documentList) {
        fetchedMarkers.clear();
        for (var item in documentList) {
          CustomMarker marker = CustomMarker(
            id: item.reference.id,
            title: item.get("title"),
            address: item.get("desc"),
            category: item.get("category"),
            location: geo.point(
                latitude: item.get("location")["geopoint"].latitude,
                longitude: item.get("location")["geopoint"].longitude),
          );
          fetchedMarkers.add(marker);
        }
        _markers.clear();
        for (var item in fetchedMarkers) {
          addMarker(item, context);
        }
        debugPrint("tamaño de fetchedMarkers: ${fetchedMarkers.length}");
      });
    });
  }

  addNewCameraPos(CameraPosition event) {
    _cameraPosController.add(event);
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    _markersSubscription.cancel();
    _cameraPosController.close();
    super.dispose();
  }
}
