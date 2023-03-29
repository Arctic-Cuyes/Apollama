import 'package:flutter/material.dart';
import 'package:zona_hub/src/constants/custom_filter_images.dart';

class TagsList {
  final List<Map<String, dynamic>> tags = [
    {
      'tag': 'Animales',
      'asset': CustomFilterIcon.pet,
      'selectedColor': Colors.brown,
      "id": "5aVNEOQ8X3bYv3XgQSZe"
    },
    {
      'tag': 'Ayuda',
      'asset': CustomFilterIcon.ayuda,
      'selectedColor': Colors.pink,
      "id": "uCRlMFDJ8nLDrdPq4Art"
    },
    {
      'tag': 'Avisos',
      'asset': CustomFilterIcon.aviso,
      'selectedColor': Colors.red,
      "id": "H3onPaVN8EUK0NKvwduN"
    },
    {
      'tag': 'Eventos',
      'asset': CustomFilterIcon.evento,
      'selectedColor': Colors.orange,
      "id": "bfR5cV0Kq4ZMfQAuPhY0"
    },
    {
      'tag': 'Salud',
      'asset': CustomFilterIcon.salud,
      'selectedColor': Colors.blue,
      "id": "Nk455xSI5Fb46u2WDCfl"
    },
  ];
}
