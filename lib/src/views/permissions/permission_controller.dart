import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class RequestPermissionController {
  final Permission _servicePermission;

  RequestPermissionController(this._servicePermission);

  final _streamController = StreamController<PermissionStatus>.broadcast();
  Stream<PermissionStatus> get onStatusChanged => _streamController.stream;

  Future<void> request() async {
    final status = await _servicePermission.request();
    _notify(status);
  }

  void _notify(PermissionStatus status) {
    if (!_streamController.isClosed && _streamController.hasListener) {
      _streamController.sink.add(status);
    }
    if (!_streamController.hasListener) {
      print("No hay listener pipipi");
    }
  }

  void notify() async {
    final status = await _servicePermission.status;
    _notify(status);
  }

  void dispose() {
    _streamController.close();
  }

  Future<PermissionStatus> check() async {
    return _servicePermission.status;
  }
}
