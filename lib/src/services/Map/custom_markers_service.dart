// ignore_for_file: constant_identifier_names

import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerIcons {
  final Future<BitmapDescriptor> avisoMarker =
      _getBitmapDesc(CustomMarkersIconPath.AVISO);
  final Future<BitmapDescriptor> ayudaMarker =
      _getBitmapDesc(CustomMarkersIconPath.AYUDA);
  final Future<BitmapDescriptor> eventoMarker =
      _getBitmapDesc(CustomMarkersIconPath.EVENTO);
  final Future<BitmapDescriptor> saludMarker =
      _getBitmapDesc(CustomMarkersIconPath.SALUD);
  final Future<BitmapDescriptor> petMarker =
      _getBitmapDesc(CustomMarkersIconPath.PET);

  static Future<Uint8List> _assetToBytes(String path, {int width = 105}) async {
    var byteData = await rootBundle.load(path);
    final bytes = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final frame = await codec.getNextFrame();
    final newByteData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return newByteData!.buffer.asUint8List();
  }

  static Future<BitmapDescriptor> _getBitmapDesc(String path) async {
    final value = await _assetToBytes(path);
    return BitmapDescriptor.fromBytes(value);
  }
}

class CustomMarkersIconPath {
  static const String AVISO = "assets/markers/marker_aviso.png";
  static const String AYUDA = "assets/markers/marker_ayuda.png";
  static const String EVENTO = "assets/markers/marker_evento.png";
  static const String SALUD = "assets/markers/marker_salud.png";
  static const String PET = "assets/markers/marker_pet.png";
}
