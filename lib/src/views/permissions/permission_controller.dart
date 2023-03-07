import 'package:permission_handler/permission_handler.dart';

class RequestPermissionController {
  final Permission _servicePermission;

  RequestPermissionController(this._servicePermission);

  Future<PermissionStatus> check() async {
    return _servicePermission.status;
  }
}
