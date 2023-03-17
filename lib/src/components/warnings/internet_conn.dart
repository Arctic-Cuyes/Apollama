import 'package:flutter/material.dart';

SnackBar showConnectionWarningFlash() {
  return SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.wifi_off,
            size: 15,
            color: Colors.white,
          ),
        ),
        Text("Sin conexión a internet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            )),
      ],
    ),
    duration: const Duration(
      minutes: 2,
    ),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.red.shade500,
    padding: const EdgeInsets.all(5),
  );
}
