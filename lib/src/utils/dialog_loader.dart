import 'package:flutter/material.dart';

openDialogLoader({
  required context,
}) {
    showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }