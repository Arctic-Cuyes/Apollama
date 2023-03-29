import 'dart:convert';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const String _API_KEY = "AIzaSyBggl8BCMdQdu6A8gC-TtUARhcZ32CTLOs";
const String _lang = "es-419";
GeoHasher geoHasher = GeoHasher();

class AddressDetail {
  String address;
  String approximate;
  String country;
  String city;
  String geohash;

  AddressDetail({
    this.address = "",
    this.country = "",
    this.approximate = "",
    this.city = "",
    this.geohash = "",
  });
}

Future<Response> callReverseGeocoding(LatLng input) async {
  String baseURL = "https://maps.googleapis.com/maps/api/geocode/json";
  String resultType = "street_address|country|locality";
  String request = "$baseURL?"
      "latlng=${input.latitude},${input.longitude}"
      "&result_type=$resultType"
      "&language=$_lang"
      "&key=$_API_KEY";
  return http.get(Uri.parse(request));
}

Future<AddressDetail?> getHumanReadableAddress(LatLng input) async {
  final addressDetail = AddressDetail();
  final response = await callReverseGeocoding(input);
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    if (body["status"] == "OK") {
      List results = body["results"];
      for (var item in results) {
        String detail = item["formatted_address"];
        if (item["types"].contains("street_address")) {
          addressDetail.address = detail;
        }
        if (item["types"].contains("premise")) {
          addressDetail.address = detail;
        }
        if (item["types"].contains("country")) {
          addressDetail.country = detail;
        }
        if (item["types"].contains("locality")) {
          addressDetail.city = detail;
        }
      }
    } else {
      debugPrint("No hay resultados xd");
    }

    addressDetail.geohash = GeoHasher().encode(
      input.longitude,
      input.latitude,
      precision: 5,
    );
    return addressDetail;
  } else {
    return null;
  }
}
