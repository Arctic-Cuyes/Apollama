import 'package:zona_hub/src/models/user_model.dart';

class Comment {
  Comment({
    required this.author,
    required this.content,
    required this.createdAt,
  });

  Comment.fromJson(Map<String, Object?> json)
      : this(
          author: json['author']! as User,
          content: json['content']! as String,
          createdAt: json['createdAt']! as String,
        );

  final User author;
  final String content;
  final String createdAt;

  Map<String, Object> toJson() {
    return {
      'author': author,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
