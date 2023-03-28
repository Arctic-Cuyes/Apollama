import 'package:flutter/material.dart';
import 'package:zona_hub/src/constants/custom_filter_images.dart';

class TagsList {
  final List<Map<String, dynamic>> tags = [
    {
      'tag': 'Animales',
      'asset': CustomFilterIcon.pet,
      'selectedColor': Colors.brown
    },
    {
      'tag': 'Ayuda',
      'asset': CustomFilterIcon.ayuda,
      'selectedColor': Colors.pink
    },
    {
      'tag': 'Avisos',
      'asset': CustomFilterIcon.aviso,
      'selectedColor': Colors.red
    },
    {
      'tag': 'Eventos',
      'asset': CustomFilterIcon.evento,
      'selectedColor': Colors.orange
    },
    {
      'tag': 'Salud',
      'asset': CustomFilterIcon.salud,
      'selectedColor': Colors.blue
    },
  ];
}
