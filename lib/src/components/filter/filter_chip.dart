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
      height: 108,
      width: 108,
      child: Column(
        children: [
          FilterChip(
            selectedColor: widget.selectedColor,
            selected: fp.filters.contains(widget.label) ,
            label: Text(widget.label), 
            onSelected: (bool selected) { fp.toggleFilter(widget.label); },
          ),
          Image.asset(widget.markerIconPath, width: 64, height: 64,),
        ],
      ),
    );
  }
}