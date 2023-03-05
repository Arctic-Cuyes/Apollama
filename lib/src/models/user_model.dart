import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/community_model.dart';
import 'package:zona_hub/src/models/post_model.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.age,
    required this.location,
    required this.upPosts,
    required this.downPosts,
    required this.communities,
    required this.createdAt,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          email: json['email']! as String,
          avatarUrl: json['avatarUrl']! as String,
          age: json['age']! as String,
          location: json['location']! as GeoPoint,
          upPosts: json['upPosts']! as List<Post>,
          downPosts: json['downPosts']! as List<Post>,
          communities: json['communities']! as List<Community>,
          createdAt: json['createdAt']! as String,
        );
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String age;
  final GeoPoint location;
  final List<Post> upPosts;
  final List<Post> downPosts;
  final List<Community> communities;
  final String createdAt;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'age': age,
      'location': location,
      'upPosts': upPosts,
      'downPosts': downPosts,
      'communities': communities,
      'createdAt': createdAt,
    };
  }
}
