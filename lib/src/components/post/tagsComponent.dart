import 'package:flutter/material.dart';
import 'package:zona_hub/src/models/tag_model.dart';

class TagsComponent extends StatefulWidget {
  final Map<String, dynamic> tagStyle;
  const TagsComponent({super.key, required this.tagStyle});

  @override
  State<TagsComponent> createState() => _TagsComponentState();
}

class _TagsComponentState extends State<TagsComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: widget.tagStyle['selectedColor'],
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.tagStyle['selectedColor'] as Color).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            widget.tagStyle['asset'], 
            height: 20,
          ),
          const SizedBox(width: 5),
          Text(
            widget.tagStyle['tag'],
            style: const TextStyle(
              // color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )
          ),
        ],
      )
    );
  }
}