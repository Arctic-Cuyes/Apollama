import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zona_hub/src/views/permissions/permission_controller.dart';
import 'package:zona_hub/src/views/root.dart';

final _controller = RequestPermissionController(Permission.locationWhenInUse);
bool _fromSettings = false;

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  late StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: const SafeArea(child: RequireWidget()),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Se construye permission page");
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.onStatusChanged.listen((status) {
      if (status == PermissionStatus.granted) {
        Geolocator.getLocationAccuracy().then((value) {
          if (value != LocationAccuracyStatus.precise) {
            showDialog(
              context: context,
              builder: (_) => (const _RequirePreciseDialog()),
            );
          } else {
            _goHome();
          }
        });
      }
      if (status == PermissionStatus.permanentlyDenied) {
        showDialog(
          context: context,
          builder: (_) => (const _RequireDialog()),
        );
      }
    });
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Root()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _fromSettings) {
      _controller.notify();
    }
    _fromSettings = false;
  }
}

class _RequireDialog extends StatelessWidget {
  const _RequireDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
        title: Text("Acceso a la ubicación"),
        content: Text(
          "No se pudo acceder a la ubicación del dispositivo.\n\nPor favor, activarlo de forma manual en configuraciones de la aplicación.",
        ),
        actionsPadding: EdgeInsets.only(right: 20, bottom: 15),
        actions: [
          _CancelarButtonWidget(),
          _ConfiguracionButtonWidget(),
        ]);
  }
}

class _RequirePreciseDialog extends StatelessWidget {
  const _RequirePreciseDialog({super.key});
  final String contenido =
      """Se necesita ubicación precisa para el correcto funcionamiento.
      \nIr a configuraciones y seguir los siguientes pasos:\n
- Ir a permisos de aplicación.
- Seleccionar ubicación.
- Seleccionar "Permitir solo con la app en uso y activar el uso de la ubicación precisa""";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Acceso a ubicación precisa"),
        content: Text(contenido),
        actions: const [
          _CancelarButtonWidget(),
          _ConfiguracionButtonWidget(),
        ]);
  }
}

class _CancelarButtonWidget extends StatelessWidget {
  const _CancelarButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.amber),
        foregroundColor: Colors.black,
      ),
      child: const Text(
        "Cancelar",
      ),
    );
  }
}

class _ConfiguracionButtonWidget extends StatelessWidget {
  const _ConfiguracionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pop(context);
        _fromSettings = await openAppSettings();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(horizontal: 15),
      ),
      child: const Text(
        "Ir a configuraciones",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class RequireWidget extends StatelessWidget {
  const RequireWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share_location_sharp,
              color: Colors.amber.shade600,
              size: 64.0,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Acceso a ubicación",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "La aplicación requiere permisos de ubicación precisa para mostrar lo que está sucediendo en tu comunidad.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _controller.request(),
              child: const Text("Permitir"),
            )
          ],
        ),
      ),
    );
  }
}
