import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class PostService {
  final CollectionReference postsRef =
      FirebaseFirestore.instance.collection('posts');
  final UserService userService = UserService();
  final AuthService authService = AuthService();
  Stream<QuerySnapshot> streamPosts() {
    final Stream<QuerySnapshot> postsStream = postsRef.snapshots();
    return postsStream;
  }

  Stream<List<Post>> getPosts() {
    return postsRef.snapshots().asyncMap((snapshot) async {
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final post = Post.fromJson(doc.data() as Map<String, dynamic>);
        post.authorData = await userService.getUserDataFromDocRef(post.author!);
        post.id = doc.id;
        post.authorData!.id = post.author!.id;
        return post;
      }));
      return posts;
    });
  }

  // create a post and set the author to the current user
  // Future createPost(Post post) async {
  // }

  // void see() {
  //   print("____________________________");
  //   final currentUser = authService.currentUser;
  //   print(currentUser);
  // }
}
