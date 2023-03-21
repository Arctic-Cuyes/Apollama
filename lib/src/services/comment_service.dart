import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/comment_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class CommentService {
  final String postId;
  late CollectionReference<Comment> commentsRef;
  CommentService({required this.postId}) {
    commentsRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .withConverter<Comment>(
          fromFirestore: (snapshots, _) =>
              Comment.fromJson(snapshots.data() as Map<String, dynamic>),
          toFirestore: (comment, _) => comment.toJson(),
        );
  }

  final UserService userService = UserService();
  final AuthService authService = AuthService();

  Stream<List<Comment>> getComments() {
    return commentsRef.snapshots().asyncMap((snapshot) async {
      final comments = await Future.wait(snapshot.docs.map((doc) async {
        final comment = doc.data();
        comment.id = doc.id;
        comment.authorData =
            await userService.getUserDataFromDocRef(comment.author!);
        comment.authorData.id = comment.author!.id;
        return comment;
      }));
      return comments;
    });
  }

  // create a comment and set the author to the current user
  Future<void> createComment(Comment comment) async {
    final user = await authService.getCurrentUser();
    comment.author = user.toDocumentReference();
    await commentsRef.add(comment);
  }

  // update a comment if the current user is the author
  Future<void> updateComment(Comment comment) async {
    if (await authService.isThisUserTheCurrentUser(
        comment.author?.id ?? comment.authorData.id!)) {
      await commentsRef.doc(comment.id).update(comment.toJson());
    }
  }

  // delete a comment if the current user is the author
  Future<void> deleteComment(Comment comment) async {
    if (await authService.isThisUserTheCurrentUser(
        comment.author?.id ?? comment.authorData.id!)) {
      await commentsRef.doc(comment.id).delete();
    }
  }
}
