import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/tag_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/utils/post_query.dart';

class PostService {
  final postsRef = FirebaseFirestore.instance
      .collection('posts')
      .withConverter<Post>(
          fromFirestore: (snapshots, _) =>
              Post.fromJson(snapshots.data() as Map<String, dynamic>),
          toFirestore: (post, _) => post.toJson());
  final UserService userService = UserService();
  final AuthService authService = AuthService();
  final TagService tagService = TagService();

  Stream<List<Post>> getPosts(
      {PostQuery query = PostQuery.all, List<Tag> tags = const <Tag>[]}) {
    checkPostQueryParams(query: query, tags: tags);
    return postsRef
        .queryBy(query: query, tags: tags)
        .snapshots()
        .asyncMap((snapshot) async {
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final post = doc.data();
        post.authorData = await userService.getUserDataFromDocRef(post.author!);
        post.id = doc.id;
        post.authorData!.id = post.author!.id;
        return post;
      }));
      return posts;
    });
  }

  // create a post and set the author to the current user
  Future<void> createPost(Post post) async {
    final user = await authService.getCurrentUser();
    post.author = user.toDocumentReference();
    await postsRef.add(post);
  }
}
