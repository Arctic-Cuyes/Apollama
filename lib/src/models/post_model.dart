import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/geo/geo_data.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/utils/json_document_reference.dart';

class Post {
  Post(
      {this.id,
      this.author,
      this.authorData,
      this.active = true,
      required this.title,
      required this.description,
      this.address,
      required this.location,
      this.createdAt,
      required this.imageUrl,
      this.ups = 0,
      this.downs = 0,
      this.puntuation = 0,
      this.tags,
      this.tagsData,
      this.community,
      this.beginDate,
      this.upVotes,
      this.downVotes,
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
          location: GeoData.fromJson(json['location'] as Map<String, dynamic>),
          address: json['address'] as String?,
          createdAt: json['createdAt'].toDate() as DateTime?,
          imageUrl: json['imageUrl'] as String? ?? '',
          ups: json['ups'] as int? ?? 0,
          downs: json['downs'] as int? ?? 0,
          puntuation: json['puntuation'] as int? ?? 0,
          tags: (json['tags'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
          community: json['community'] as String? ?? '',
          beginDate: json['beginDate'] != null
              ? DateTime.parse(json['beginDate'])
              : null,
          endDate: DateTime.parse(json['endDate']),
          active: json['active'] as bool? ?? true,
          upVotes: (json['upVotes'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
          downVotes: (json['downVotes'] as List<dynamic>?)
                  ?.map((ref) =>
                      JsonDocumentReference(ref.path).toDocumentReference())
                  .toList() ??
              [],
        );

  late String? id;
  late DocumentReference<Map<String, dynamic>>? author;
  late bool active;
  late UserModel? authorData;
  final String title;
  final String description;
  final GeoData location;
  final String? address;
  final DateTime? createdAt;
  final String? imageUrl;
  final int? ups;
  final int? downs;
  final int? puntuation;
  late List<DocumentReference<Map<String, dynamic>>>? tags;
  late List<Tag>? tagsData;
  final String? community;
  final DateTime? beginDate;
  final DateTime endDate;
  late List<DocumentReference<Map<String, dynamic>>>? upVotes;
  late List<DocumentReference<Map<String, dynamic>>>? downVotes;

  Map<String, Object?> toJson() {
    return {
      if (author != null) 'author': author,
      'title': title,
      'description': description,
      'location': location.toJson(),
      if (address != null) 'address': address,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'ups': ups ?? 0,
      'downs': downs ?? 0,
      'puntuation': puntuation ?? 0,
      'tags': tags,
      'community': community,
      if (beginDate != null) 'beginDate': beginDate!.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'active': active,
      'upVotes': upVotes,
      'downVotes': downVotes,
    };
  }

  DocumentReference<Map<String, dynamic>> toDocumentReference() {
    return FirebaseFirestore.instance.collection('posts').doc(id);
  }
}
