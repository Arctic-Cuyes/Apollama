import 'package:flutter/material.dart';

class FilterChipComponent extends StatefulWidget {
  final int index;
  final Widget label;

  const FilterChipComponent({
    super.key,
    required this.index,
    required this.label,
  });

  @override
  State<FilterChipComponent> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterChipComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: FilterChip(
        selected: true ,
        label: Text("Cualquier cosa"), 
        avatar: widget.label,
        onSelected: (bool selected) {debugPrint(widget.index.toString());},
      ),
    );
  }
}