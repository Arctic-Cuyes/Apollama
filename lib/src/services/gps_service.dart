import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

class GpsService {
  Future<Position?> determinePosition() async {
    late Position? currentPos;
    try {
      currentPos = await Geolocator.getCurrentPosition();
    } on LocationServiceDisabledException catch (ex) {
      debugPrint(ex.toString());
      currentPos = null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return currentPos;
  }

  Future<Position?> determineLastPosition() async {
    return await Geolocator.getLastKnownPosition();
  }
}
