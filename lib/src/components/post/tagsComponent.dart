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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            widget.tagStyle['asset'], 
            height: 20,
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              Text(widget.tagStyle['tag']),
              Container(
                // height: 2,
                color: widget.tagStyle['selectedColor'],
              ),
            ],
          ),
        ],
      )
    );
  }
}