import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

class FlashMessage {
  static showErrorMessage(message, context) {
    Flushbar(
      duration: const Duration(seconds: 5),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.BOTTOM, // posición en la parte superior
      icon: const Icon(Icons.error, color: Colors.white), // ícono opcional
      backgroundColor: Colors.red, // color de fondo opcional
      isDismissible: true,
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      animationDuration: const Duration(milliseconds: 500),

      title: "Error",
      message: message,
      
      boxShadows: const [
        BoxShadow(
          blurRadius: 5.0,
          color: Color.fromARGB(100, 244, 67, 54),
          spreadRadius: 4.0,
          offset: Offset(2.0, 2.0),
        ),
      ],
    ).show(context);
    return;
  }
}

