import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/views/map/map_controller.dart';

class MapPageProvider extends StatelessWidget {
  const MapPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapController>(
      create: (context) => MapController(),
      child: const _MapPage(),
    );
  }
}

class _MapPage extends StatelessWidget {
  const _MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<MapController>(
            builder: (context, controller, _) {
              debugPrint("Se construye solo");
              return GoogleMap(
                markers: controller.markers,
                initialCameraPosition: controller.initialCameraPos,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                zoomControlsEnabled: false,
                onTap: (context) => debugPrint("Presionado en mapa"),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Provider.of<MapController>(context, listen: false)
            .addExampleMarker(),
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
