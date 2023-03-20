import 'package:flutter/material.dart';

showSnackBar({
    required context,
    Icon? icon,
    required String text,
    Color? textColor,
    Duration? duration,
    Color? backgroundcolor
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon ??
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: icon,
              ),
          Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
      duration: duration ?? const Duration(seconds: 10),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: backgroundcolor ?? Colors.red.shade500,
      padding: const EdgeInsets.all(5),
    )
  );
}
