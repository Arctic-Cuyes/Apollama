 import 'package:flutter/material.dart';

 Widget buildTextField({
    required bool obscureText,
    required TextEditingController controller,
    Widget? prefixedIcon,
    String? hintText,
  }) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.amber,
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }