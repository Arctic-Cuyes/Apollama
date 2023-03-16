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
            return Consumer<MapController>(
              builder: (context, controller, _) {
                debugPrint("Se construye el mapa");
                return GoogleMapWidget(
                  controller: controller,
                  snapshot: snapshot,
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Provider.of<MapController>(context, listen: false)
            .addExampleMarker(context),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}

class GoogleMapWidget extends StatelessWidget {
  final MapController controller;
  final AsyncSnapshot<CameraPosition> snapshot;

  const GoogleMapWidget({
    super.key,
    required this.controller,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: controller.markers,
      initialCameraPosition: snapshot.data!,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      mapType: MapType.normal,
      compassEnabled: true,
      zoomControlsEnabled: false,
      onTap: (_) => debugPrint("Presionado en mapa"),
    );
  }
}
