import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class AddressAutocompletePage extends StatefulWidget {
  const AddressAutocompletePage({super.key});

  @override
  State<AddressAutocompletePage> createState() =>
      _AddressAutocompletePageState();
}

class _AddressAutocompletePageState extends State<AddressAutocompletePage> {
  final _addressController = TextEditingController();
  final uuid = const Uuid();
  final String PLACES_API_KEY = "";
  String lang = "es-419";

  String? _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    _addressController.addListener(() {
      _onChanged();
    });
    super.initState();
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    _getLocationResults(_addressController.text);
  }

  void _getLocationResults(String input) async {
    if (_addressController.text.isNotEmpty) {
      const int RADIUS = 25000;
      String lang = "es-419";
      String baseURL =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request = "$baseURL?input=$input"
          "&radius=$RADIUS"
          "&language=$lang"
          "&key=$PLACES_API_KEY"
          "&sessiontoken=$_sessionToken";
      final response = await http.get(Uri.parse(request));
      debugPrint(_sessionToken);
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)["predictions"];
        });
      } else {
        debugPrint("Failed to load predictions");
      }
    }
  }

  void _callPlaceDetailsApi(String place_id) async {
    String baseURL =
        "https://maps.googleapis.com/maps/api/place/details/output?parameters";
    String fields = "formatted_address" "%2C" "geometry" "%2C";
    String request = "$baseURL?place_id=$place_id"
        "&fields=$fields"
        "&language=$lang"
        "&key=$PLACES_API_KEY"
        "&sessiontoken=$_sessionToken";
    final response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)["result"];
      });
    } else {
      debugPrint("Failed to load predictions");
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: "Atrás",
            onPressed: () {
              final data = {"place_id": "", "description": ""};
              _callPlaceDetailsApi(data["place_id"]!);
              Navigator.of(context).pop(data);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            Hero(
              tag: "address",
              child: Material(
                child: TextFormField(
                  controller: _addressController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_pin),
                    labelText: 'Dirección',
                  ),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _placeList.length < 5 ? _placeList.length : 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placeList[index]["description"]),
                  onTap: () {
                    final Map<String, String> data = {
                      "place_id": _placeList[index]["place_id"],
                      "description": _placeList[index]["description"]
                    };
                    _callPlaceDetailsApi(data["place_id"]!);
                    Navigator.of(context).pop(data);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
