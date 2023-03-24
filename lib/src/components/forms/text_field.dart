import 'package:flutter/material.dart';
import 'package:zona_hub/src/styles/global.colors.dart';

 Widget buildTextField({
    required bool obscureText,
    required TextEditingController controller,
    Widget? prefixedIcon,
    String? hintText,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,

  }) {
    return TextFormField(
      validator: validator,
      onChanged: onChanged,


      controller: controller,
      // cursorColor: Colors.white,
      cursorWidth: 2,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),

        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: GlobalColors.mainColor,
            width: 2,
          ),

        ),

        

        

        filled: true,
        prefixIcon: prefixedIcon,
        prefixIconColor: GlobalColors.mainColor,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          // fontFamily: 'PTSans',
        ),
      ),

    );
  }