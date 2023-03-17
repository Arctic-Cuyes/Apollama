import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/comment_model.dart';
import 'package:zona_hub/src/services/user_service.dart';

class CommentService {
  final CollectionReference commentsRef =
      FirebaseFirestore.instance.collection('comments');
  final UserService userService = UserService();

  Stream<List<Comment>> getComments() {
    return commentsRef.snapshots().asyncMap((snapshot) async {
      final comments = await Future.wait(snapshot.docs.map((doc) async {
        final comment = Comment.fromJson(doc.data() as Map<String, dynamic>);
        comment.id = doc.id;
        comment.authorData =
            await userService.getUserDataFromDocRef(comment.author);
        comment.authorData.id = comment.author.id;
        return comment;
      }));
      return comments;
    });
  }

  // create a comment and set the author to the current user
  // Future<void> createComment(Comment comment) async {
  //   await commentsRef.add(comment.toJson());
  // }

  // update a comment if the current user is the author
  // Future<void> updateComment(Comment comment) async {
  //   await commentsRef.doc(comment.id).update(comment.toJson());
  // }

  // delete a comment if the current user is the author
  // Future<void> deleteCommentById(String id) async {
  //   await commentsRef.doc(id).delete();
  // }
}
