import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/providers/filters_provider.dart';

class FilterChipComponent extends StatefulWidget {
  final String label;
  final String markerIconPath;
  final Color selectedColor;

  const FilterChipComponent({
    super.key,
    required this.label,
    required this.markerIconPath,
    required this.selectedColor,
  });

  @override
  State<FilterChipComponent> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterChipComponent> {
  @override
  Widget build(BuildContext context) {
    final fp = context.watch<FilterProvider>();
    return SizedBox(
      height: 128,
      width: 120,
      child: Column(
        children: [
          FilterChip(
            avatar: CircleAvatar(backgroundColor: widget.selectedColor, child: Image.asset(widget.markerIconPath)),
            checkmarkColor: Colors.white,
            backgroundColor: Colors.grey[500],
            selectedColor: widget.selectedColor,
            selected: fp.filters.contains(widget.label),
            label: Text(widget.label, style: const TextStyle(color: Colors.white),), 
            onSelected: (bool selected) { fp.toggleFilter(widget.label); },
          ),
          Image.asset(widget.markerIconPath, width: 80, height: 80,),
        ],
      ),
    );
  }
}