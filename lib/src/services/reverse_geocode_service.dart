import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const String _API_KEY = "AIzaSyBggl8BCMdQdu6A8gC-TtUARhcZ32CTLOs";
const String _lang = "es-419";

class AddressDetail {
  String address;
  String approximate;
  String country;
  String city;

  AddressDetail({
    this.address = "",
    this.country = "",
    this.approximate = "",
    this.city = "",
  });
}

Future<AddressDetail?> getHumanReadableAddress(LatLng input) async {
  final addressDetail = AddressDetail();
  String baseURL = "https://maps.googleapis.com/maps/api/geocode/json";
  String resultType = "street_address|country|locality";
  String request = "$baseURL?"
      "latlng=${input.latitude},${input.longitude}"
      "&result_type=$resultType"
      "&language=$_lang"
      "&key=$_API_KEY";
  final response = await http.get(Uri.parse(request));

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
    return addressDetail;
  } else {
    return null;
  }
}
