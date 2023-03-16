import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/utils/json_document_reference.dart';

class Post {
  Post({
    this.id,
    this.author,
    required this.title,
    required this.description,
    this.location,
    this.createdAt,
    required this.imageUrl,
    this.ups = 0,
    this.downs = 0,
    this.comments,
    this.tags,
    this.community,
    this.reports,
  });

  Post.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String?,
          author: json['author'] != null
              ? JsonDocumentReference((json['author']
                          as DocumentReference<Map<String, dynamic>>)
                      .path)
                  .toDocumentReference()
              : null,
          title: json['title'] as String? ?? '',
          description: json['description'] as String? ?? '',
          location: json['location'] as Map<String, dynamic>?,
          createdAt: json['createdAt'] as String?,
          imageUrl: json['imageUrl'] as String? ?? '',
          ups: json['ups'] as int? ?? 0,
          downs: json['downs'] as int? ?? 0,
          comments: (json['comments'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
          tags: (json['tags'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
          community: json['community'] != null
              ? JsonDocumentReference(json['community']).toDocumentReference()
              : null,
          reports: (json['reports'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
        );

  late String? id;
  final DocumentReference<Map<String, dynamic>>? author;
  final String title;
  final String description;
  final Map<String, dynamic>? location;
  final String? createdAt;
  final String imageUrl;
  final int? ups;
  final int? downs;
  final List<DocumentReference<Map<String, dynamic>>>? comments;
  final List<DocumentReference<Map<String, dynamic>>>? tags;
  final DocumentReference<Map<String, dynamic>>? community;
  final List<DocumentReference<Map<String, dynamic>>>? reports;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      if (author != null)
        'author': JsonDocumentReference(author!.path).toJson(),
      'title': title,
      'description': description,
      if (location != null) 'location': location,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'ups': ups ?? 0,
      'downs': downs ?? 0,
      'comments': comments
          ?.map((ref) => JsonDocumentReference(ref.path).toJson())
          .toList(),
      'tags':
          tags?.map((ref) => JsonDocumentReference(ref.path).toJson()).toList(),
      if (community != null)
        'community': JsonDocumentReference(community!.path).toJson(),
      'reports': reports
          ?.map((ref) => JsonDocumentReference(ref.path).toJson())
          .toList(),
    };
  }
}
