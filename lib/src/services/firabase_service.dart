import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPosts() async {
  List posts = [];
  QuerySnapshot snapshot = await db.collection('posts').get();
  snapshot.docs.forEach((doc) {
    posts.add(doc.data());
  });
  return posts;
}
