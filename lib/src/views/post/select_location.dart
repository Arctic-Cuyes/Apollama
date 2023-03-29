import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zona_hub/src/services/Map/gps_service.dart';

class SelectLocationWidget extends StatefulWidget {
  final LatLng? lastCameraPos;
  const SelectLocationWidget({super.key, required this.lastCameraPos});

  @override
  State<SelectLocationWidget> createState() => _SelectLocationWidgetState();
}

class _SelectLocationWidgetState extends State<SelectLocationWidget> {
  late final GpsService gpsService;
  LatLng? _result;
  late CameraPosition _currentCameraPos;

  @override
  void initState() {
    super.initState();
    gpsService = GpsService();
  }

  Future<CameraPosition?> _getCameraPosition() async {
    if (widget.lastCameraPos != null) {
      _currentCameraPos = CameraPosition(
        target: widget.lastCameraPos!,
        zoom: 17.5,
      );
    } else {
      Position? currentPos = await gpsService.determinePosition();
      if (currentPos != null) {
        _currentCameraPos = CameraPosition(
          target: LatLng(currentPos.latitude, currentPos.longitude),
          zoom: 15,
        );
      } else {
        return null;
      }
    }
    return _currentCameraPos;
  }

  void _selectLocation() {
    _result = LatLng(
        _currentCameraPos.target.latitude, _currentCameraPos.target.longitude);
    _goToNewPost(_result);
  }

  void _goToNewPost(LatLng? result) {
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Ubicación de la publicación"),
            leading: IconButton(
              tooltip: "Atrás",
              onPressed: () {
                _goToNewPost(null);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            )),
        body: FutureBuilder(
          future: _getCameraPosition(),
          builder:
              (BuildContext context, AsyncSnapshot<CameraPosition?> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    initialCameraPosition: snapshot.data!,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    onCameraMove: (position) {
                      _currentCameraPos = position;
                    },
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: IgnorePointer(
                      child: Icon(
                        Icons.gps_fixed,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      onPressed: () => _selectLocation(),
                      icon: const Icon(Icons.location_pin),
                      label: const Text("Seleccionar ubicación"),
                    ),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
