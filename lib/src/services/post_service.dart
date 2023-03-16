import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/user_service.dart';

class PostService {
  final CollectionReference postsRef =
      FirebaseFirestore.instance.collection('posts');
  final UserService userService = UserService();

  Stream<QuerySnapshot> streamPosts() {
    final Stream<QuerySnapshot> postsStream = postsRef.snapshots();
    return postsStream;
  }

  Stream<List<Post>> getPosts() {
    return postsRef.snapshots().asyncMap((snapshot) async {
      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final post = Post.fromJson(doc.data() as Map<String, dynamic>);
        post.authorData =
            await userService.getUserDataFromDocRef(post.author!);
        return post;
      }));
      return posts;
    });
  }

  // Future<void> see() async {
  //   print("-------------------------------");
  //   postsRef.snapshots().forEach((snapshot) {
  //     snapshot.docs
  //         .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
  //         .forEach((Post post) async {
  //       post.authorData =
  //           await userService.getUserDataFromDocRef(post.author!);
  //       print(post.authorData!.name);
  //     });
  //   });
  // }
}
