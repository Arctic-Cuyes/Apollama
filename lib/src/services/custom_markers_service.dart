// ignore_for_file: constant_identifier_names

import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkers {
  static final Future<BitmapDescriptor> _avisoMarker =
      _getBitmapDesc(CustomMarkersPath.AVISO);
  static final Future<BitmapDescriptor> _ayudaMarker =
      _getBitmapDesc(CustomMarkersPath.AYUDA);
  static final Future<BitmapDescriptor> _eventoMarker =
      _getBitmapDesc(CustomMarkersPath.EVENTO);
  static final Future<BitmapDescriptor> _saludMarker =
      _getBitmapDesc(CustomMarkersPath.SALUD);
  static final Future<BitmapDescriptor> _vetMarker =
      _getBitmapDesc(CustomMarkersPath.VET);

  static Future<Uint8List> _assetToBytes(String path, {int width = 100}) async {
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

class CustomMarkersPath {
  static const String AVISO = "/assets/markers/marker_aviso.png";
  static const String AYUDA = "/assets/markers/marker_ayuda.png";
  static const String EVENTO = "/assets/markers/marker_evento.png";
  static const String SALUD = "/assets/markers/marker_salud.png";
  static const String VET = "/assets/markers/marker_vet.png";
}
