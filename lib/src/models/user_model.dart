import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/utils/json_document_reference.dart';

class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.age,
    this.location,
    this.upPosts,
    this.downPosts,
    this.communities,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String? ??
          'https://cdn-icons-png.flaticon.com/512/1050/1050915.png',
      age: json['age'] as int?,
      location: json['location'] as Map<String, dynamic>?,
      upPosts: (json['upPosts'] as List<dynamic>?)
          ?.map((ref) => JsonDocumentReference(ref.path).toDocumentReference())
          .toList(),
      downPosts: (json['downPosts'] as List<dynamic>?)
          ?.map((ref) => JsonDocumentReference(ref.path).toDocumentReference())
          .toList(),
      communities: (json['communities'] as List<dynamic>?)
          ?.map((ref) => JsonDocumentReference(ref.path).toDocumentReference())
          .toList(),
      createdAt: json['createdAt'] as String?,
    );
  }

  String? id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int? age;
  final Map<String, dynamic>? location;
  final List<DocumentReference<Map<String, dynamic>>>? upPosts;
  final List<DocumentReference<Map<String, dynamic>>>? downPosts;
  final List<DocumentReference<Map<String, dynamic>>>? communities;
  final String? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'age': age,
      'location': location,
      'upPosts': upPosts ?? [],
      'downPosts': downPosts ?? [],
      'communities': communities ?? [],
      'createdAt': createdAt,
    };
  }

  DocumentReference<Map<String, dynamic>> toDocumentReference() {
    return FirebaseFirestore.instance.collection('users').doc(id);
  }
}
