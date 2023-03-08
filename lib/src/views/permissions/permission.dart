import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zona_hub/src/views/permissions/permission_controller.dart';
import 'package:zona_hub/src/views/root.dart';

final _controller = RequestPermissionController(Permission.locationWhenInUse);

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
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.onStatusChanged.listen((status) {
      if (status == PermissionStatus.granted) {
        _goHome();
      }
      if (status == PermissionStatus.permanentlyDenied) {
        showDialog(
          context: context,
          builder: (_) => (const RequireDialog()),
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
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      _controller.notify();
    }
  }
}

class RequireDialog extends StatelessWidget {
  const RequireDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("INFO"),
        content: const Text(
          "No se pudo recuperar la ubicación. Por favor, activarlo de forma manual",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
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
              "Go To Settings",
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
              "La aplicación requiere permisos de ubicación para mostrar los eventos cercanos a tu ubicación",
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
