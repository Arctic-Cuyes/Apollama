import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_hub/src/views/map/marker_examples.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final geo = Geoflutterfire();
FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getExampleMarkers() async {
  List exampleMarkers = [];
  QuerySnapshot snapshot = await db.collection('example_markers').get();
  for (var doc in snapshot.docs) {
    CustomMarker item = CustomMarker(
      id: doc.reference.id,
      title: doc.get("title"),
      address: doc.get("desc"),
      category: doc.get("category"),
      location: geo.point(
          latitude: doc.get("location")["geopoint"].latitude,
          longitude: doc.get("location")["geopoint"].longitude),
    );
    exampleMarkers.add(item);
  }

  return exampleMarkers;
}

Stream<List<DocumentSnapshot>> _getStreamNearMarkers() {
  var center = geo.point(latitude: -8.118274, longitude: -79.032745);
  var collectionReference = db.collection('example_markers');
  double radius = 50;
  String field = 'location';
  Stream<List<DocumentSnapshot>> stream = geo
      .collection(collectionRef: collectionReference)
      .within(center: center, radius: radius, field: field);
  return stream;
}

StreamSubscription<List<DocumentSnapshot>> getNearMarkers(List exampleMarkers) {
  return _getStreamNearMarkers().listen((List<DocumentSnapshot> documentList) {
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
      exampleMarkers.add(marker);
    }
  });
}

bool checkCircunferenceFunc(LatLng center, LatLng point, {num radius = 0.05}) {
  num x_h = point.latitude - center.latitude;
  num y_k = point.longitude - center.longitude;
  //Ecuación de la circunferencia
  num value = pow(x_h, 2) + pow(y_k, 2);
  num aa = pow(radius, 2);
  return value <= aa;
}
