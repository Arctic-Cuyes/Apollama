import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/views/map/map_controller.dart';

class MapPageProvider extends StatelessWidget {
  const MapPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapController>(
      create: (context) => MapController(context),
      child: const _MapPage(),
    );
  }
}

class _MapPage extends StatelessWidget {
  const _MapPage({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint("Se construye pagina de mapa");
    return Scaffold(
      body: FutureBuilder(
        future:
            Provider.of<MapController>(context, listen: false).initialCameraPos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Consumer<MapController>(
                  builder: (context, controller, _) {
                    debugPrint("Se construye el mapa");
                    return GoogleMapWidget(
                      controller: controller,
                      snapshot: snapshot,
                    );
                  },
                ),
                const IgnorePointer(
                  child: Icon(
                    Icons.gps_fixed,
                    color: Colors.red,
                    size: 20,
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  final MapController controller;
  final AsyncSnapshot<CameraPosition> snapshot;

  const GoogleMapWidget({
    super.key,
    required this.controller,
    required this.snapshot,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  CameraPosition? _currentCameraPos;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: widget.controller.markers,
      initialCameraPosition: widget.snapshot.data!,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapType: MapType.normal,
      compassEnabled: true,
      // minMaxZoomPreference: const MinMaxZoomPreference(10, 17.5),
      zoomControlsEnabled: false,
      onTap: (_) => debugPrint("Presionado en mapa"),
      onCameraIdle: () {
        if (_currentCameraPos != null) {
          widget.controller.addNewCameraPos(_currentCameraPos!);
        }
      },
      onCameraMove: (position) {
        _currentCameraPos = position;
      },
    );
  }
}
