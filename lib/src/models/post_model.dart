import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/comment_model.dart';
import 'package:zona_hub/src/models/community_model.dart';
import 'package:zona_hub/src/models/report_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/models/user_model.dart';

class Post {
  Post(
      {required this.id,
      required this.author,
      required this.title,
      required this.description,
      required this.location,
      required this.createdAt,
      required this.images,
      required this.ups,
      required this.downs,
      required this.comments,
      required this.tags,
      required this.community,
      required this.reports});

  Post.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String,
          author: json['author'] as User,
          title: json['title'] as String,
          description: json['description'] as String,
          location: json['location'] as GeoPoint,
          createdAt: json['createdAt'] as String,
          images: json['images'] as List<String>,
          ups: json['ups'] as int,
          downs: json['downs'] as int,
          comments: json['comments'] as List<Comment>,
          tags: json['tags'] as List<Tag>,
          community: json['community'] as Community,
          reports: json['reports'] as List<Report>,
        );

  final String id;
  final User author;
  final String title;
  final String description;
  final GeoPoint location;
  final String createdAt;
  final List<String> images;
  final int ups;
  final int downs;
  final List<Comment> comments;
  final List<Tag> tags;
  final Community community;
  final List<Report> reports;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'description': description,
      'location': location,
      'createdAt': createdAt,
      'images': images,
      'ups': ups,
      'downs': downs,
      'comments': comments,
      'tags': tags,
      'community': community,
      'reports': reports,
    };
  }
}
