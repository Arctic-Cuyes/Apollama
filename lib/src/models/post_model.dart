import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/utils/json_document_reference.dart';

class Post {
  Post(
      {this.id,
      this.author,
      this.authorData,
      required this.title,
      required this.description,
      this.address,
      this.location,
      this.createdAt,
      required this.imageUrl,
      this.ups = 0,
      this.downs = 0,
      this.tags,
      this.tagsData,
      this.community,
      this.beginDate,
      required this.endDate});

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
          location: json['location'] as GeoPoint?,
          address: json['address'] as String?,
          createdAt: json['createdAt'] as DateTime?,
          imageUrl: json['imageUrl'] as String? ?? '',
          ups: json['ups'] as int? ?? 0,
          downs: json['downs'] as int? ?? 0,
          tags: (json['tags'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
          community: json['community'] != null
              ? JsonDocumentReference(json['community']).toDocumentReference()
              : null,
          beginDate: json['beginDate'] != null
              ? DateTime.parse(json['beginDate'])
              : null,
          endDate: DateTime.parse(json['endDate']),
        );

  late String? id;
  late DocumentReference<Map<String, dynamic>>? author;
  late UserModel? authorData;
  final String title;
  final String description;
  final GeoPoint? location;
  final String? address;
  final DateTime? createdAt;
  final String imageUrl;
  final int? ups;
  final int? downs;
  late List<DocumentReference<Map<String, dynamic>>>? tags;
  late List<Tag>? tagsData;
  final DocumentReference<Map<String, dynamic>>? community;
  final DateTime? beginDate;
  final DateTime endDate;

  Map<String, Object?> toJson() {
    return {
      if (author != null) 'author': author,
      'title': title,
      'description': description,
      if (location != null) 'location': location,
      if (address != null) 'address': address,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'ups': ups ?? 0,
      'downs': downs ?? 0,
      'tags': tags,
      if (community != null) 'community': community,
      if (beginDate != null) 'beginDate': beginDate!.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
