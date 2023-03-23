import 'dart:async';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/post_service.dart';

final geo = Geoflutterfire();

Stream<List<DocumentSnapshot<Post>>> getStreamNearMarkers(
    CameraPosition cameraPos) {
  var center = geo.point(
    latitude: cameraPos.target.latitude,
    longitude: cameraPos.target.longitude,
  );
  var collectionReference = PostService().postsRef;
  double radius = 4.5;
  String field = 'location';
  Stream<List<DocumentSnapshot<Post>>> stream =
      geo.collectionWithConverter(collectionRef: collectionReference).within(
          center: center,
          radius: radius,
          field: field,
          geopointFrom: (x) {
            return x.location.geopoint;
          });

  return stream;
}

// bool checkCircunferenceFunc(LatLng center, LatLng point, {num radius = 0.05}) {
//   num x_h = point.latitude - center.latitude;
//   num y_k = point.longitude - center.longitude;
//   //Ecuación de la circunferencia
//   num value = pow(x_h, 2) + pow(y_k, 2);
//   num aa = pow(radius, 2);
//   return value <= aa;
// }
