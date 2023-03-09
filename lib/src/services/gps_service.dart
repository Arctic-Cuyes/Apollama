import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

class GpsService {
  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    bool requestServiceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      requestServiceEnabled = await loc.Location().requestService();
      if (!requestServiceEnabled) {
        return null;
      }
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position?> determineLastPosition() async {
    return await Geolocator.getLastKnownPosition();
  }
}
