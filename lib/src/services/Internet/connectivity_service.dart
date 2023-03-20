import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/warnings/internet_conn.dart';

class InternetValidationService {
  final conn = Connectivity();
  late Stream<ConnectivityResult> _subscription;
  Stream<ConnectivityResult> get subscription => _subscription;

  InternetValidationService() {
    _subscription = conn.onConnectivityChanged;
  }

  @Deprecated("No útil. Usar mejor isConnected junto a subscription")
  Future<bool> checkConnectivity() async {
    final result = await conn.checkConnectivity();
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile;
  }

  bool isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile;
  }

  void showConnectionSnackbar(BuildContext context, ConnectivityResult result) {
    if (!isConnected(result)) {
      ScaffoldMessenger.of(context).showSnackBar(showConnectionWarningFlash());
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }
}
