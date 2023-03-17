import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/models/utils/json_document_reference.dart';

class Comment {
  Comment({
    this.id,
    required this.author,
    required this.content,
    required this.createdAt,
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
  final DocumentReference<Map<String, dynamic>> author;
  late User authorData;
  final String content;
  final String createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'author': JsonDocumentReference(author.path).toJson(),
      'content': content,
      'createdAt': createdAt,
    };
  }
}
