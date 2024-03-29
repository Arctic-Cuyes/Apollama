import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/utils/json_document_reference.dart';

class Comment {
  Comment({
    this.id,
    this.author,
    required this.content,
    this.createdAt,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String? ?? '',
          author: JsonDocumentReference(
                  (json['author'] as DocumentReference<Map<String, dynamic>>)
                      .path)
              .toDocumentReference(),
          content: json['content']! as String,
          createdAt: json['createdAt']! as String,
        );

  late String? id;
  late DocumentReference<Map<String, dynamic>>? author;
  late UserModel authorData;
  final String content;
  late String? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
