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
          child: SafeArea(child: RequireWidget()),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
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
          builder: (_) => (const RequireDialog()),
        );
      }
      debugPrint("Llega aqui");
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
    // TODO: implement dispose
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

class RequireDialog extends StatelessWidget {
  const RequireDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("INFO"),
        content: const Text(
          "No se pudo recuperar el acceso a la ubicación. Por favor, activarlo de forma manual en configuraciones",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _fromSettings = await openAppSettings();
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Colors.amber,
              ),
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            child: const Text(
              "Ir a configuraciones",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
            ),
          )
        ]);
  }
}

class RequireWidget extends StatelessWidget {
  const RequireWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Acceso a ubicación",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "La aplicación requiere permisos de ubicación precisa para mostrar los eventos cercanos a tu ubicación",
              textAlign: TextAlign.center,
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

class _RequirePreciseDialog extends StatelessWidget {
  const _RequirePreciseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Aviso sobre ubicación"),
        content: const Text(
            "La aplicación require ubicación precisa. Por favor dar este permiso en el menú de nuevo o ir a configuraciones si no aparece."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              _fromSettings = await openAppSettings();
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Colors.amber,
              ),
              padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
            child: const Text(
              "Ir a configuraciones",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
            ),
          )
        ]);
  }
}
