// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_hub/src/constants/custom_marker_images.dart';
import 'package:zona_hub/src/constants/tags_list.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/services/post_service.dart';
import 'package:zona_hub/src/views/map/marker_bottom_sheet.dart';
import '../../services/Map/gps_service.dart';

class MapController extends ChangeNotifier {
  late final BitmapDescriptor avisoMarker;
  late final BitmapDescriptor ayudaMarker;
  late final BitmapDescriptor eventoMarker;
  late final BitmapDescriptor saludMarker;
  late final BitmapDescriptor petMarker;

  late CameraPosition _currentCameraPos;
  late final CustomMarkerIcons _markersIconsService;
  late final GpsService _gpsService;
  late final StreamSubscription _markersSubscription;
  StreamSubscription? _nearMarkersFetch;
  late final StreamController<CameraPosition> _cameraPosController;

  late final List<Post> fetchedPosts;
  final Map<MarkerId, Marker> _markers = {};

  late bool isDisposed;
  late final Geoflutterfire geo;

  final PostService postService = PostService();

  MapController(BuildContext context) {
    _markersIconsService = CustomMarkerIcons();
    _gpsService = GpsService();
    isDisposed = false;
    _cameraPosController = StreamController();
    geo = Geoflutterfire();
    fetchedPosts = [];
    loadMarkers(context);
  }

  Set<Marker> get markers => _markers.values.toSet();

  Future<CameraPosition> get initialCameraPos async {
    Position? initialPosition = await _gpsService.determinePosition();
    if (initialPosition != null) {
      _currentCameraPos = CameraPosition(
          target: LatLng(initialPosition.latitude, initialPosition.longitude),
          zoom: 15);
    } else {
      initialPosition = await _gpsService.determineLastPosition();
      if (initialPosition != null) {
        _currentCameraPos = CameraPosition(
            target: LatLng(initialPosition.latitude, initialPosition.longitude),
            zoom: 15);
      } else {
        _currentCameraPos =
            const CameraPosition(target: LatLng(0, 0), zoom: 0.0);
      }
    }
    addNewCameraPos(_currentCameraPos);
    return _currentCameraPos;
  }

  void loadMarkers(BuildContext context) async {
    avisoMarker = await _markersIconsService.avisoMarker;
    ayudaMarker = await _markersIconsService.ayudaMarker;
    eventoMarker = await _markersIconsService.eventoMarker;
    petMarker = await _markersIconsService.petMarker;
    saludMarker = await _markersIconsService.saludMarker;

    _markersSubscription = _markersListener(context);
  }

  BitmapDescriptor assignIcon(Tag tag) {
    String categoria = tag.name;
    if (categoria == "Animales") {
      return petMarker;
    }
    if (categoria == "Avisos") {
      return ayudaMarker;
    }
    if (categoria == "Salud") {
      return saludMarker;
    }
    if (categoria == "Eventos") {
      return eventoMarker;
    }
    if (categoria == "Ayuda") {
      return avisoMarker;
    }
    return petMarker;
  }

  void addMarker(Post cMarker, BuildContext context) {
    debugPrint("add marker");
    debugPrint(cMarker.toJson().toString());
    final id = cMarker.id;
    final markerId = MarkerId(id.toString());
    final icon = assignIcon(cMarker.tagsData![0]);
    final newMarker = Marker(
      markerId: markerId,
      position: LatLng(cMarker.location.geopoint.latitude,
          cMarker.location.geopoint.longitude),
      icon: icon,
      draggable: true,
      onTap: () {
        debugPrint(markerId.toString());
        showMarkerBottomSheet(context, cMarker);
      },
    );

    _markers[markerId] = newMarker;
  }

  StreamSubscription<dynamic> _markersListener(BuildContext context) {
    _nearMarkersFetch = postService.getPosts().listen((List<Post> event) {
      fetchedPosts.clear();
      for (var item in event) {
        // final marker = Post.fromJson(item as Map<String, dynamic>);
        fetchedPosts.add(item);
      }
      _markers.clear();
      for (var item in fetchedPosts) {
        addMarker(item, context);
      }
      notifyListeners();
    });
    return _nearMarkersFetch!;
  }

  addNewCameraPos(CameraPosition event) {
    if (!_cameraPosController.isClosed) {
      _cameraPosController.add(event);
    }
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
    _nearMarkersFetch?.cancel();
    _cameraPosController.close();
    super.dispose();
  }
}
