import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/views/map/map_controller.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<MapController>(
            builder: (context, controller, _) {
              return GoogleMap(
                markers: controller.markers,
                initialCameraPosition: controller.initialCameraPos,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
                onTap: (context) => debugPrint("Hola"),
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
