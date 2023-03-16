import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/user_model.dart';

class UserService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  Future<User> getUserDataFromDocRef(DocumentReference userRef) async {
    DocumentSnapshot userSnapshot = await userRef.get();
    return User.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }

  // testing code
  // Future<void> see(DocumentReference userRef) async {
  //   print("-------------------------------");
  //   DocumentSnapshot userSnapshot = await userRef.get();
  //   User u = User.fromJson(userSnapshot.data()! as Map<String, Object?>);
  //   // acces to the user data
  //   Iterable<Future> upPostsContent = u.upPosts!.map((e) async {
  //     DocumentSnapshot postSnapshot = await e.get();
  //     return postSnapshot['description'];
  //   });

  //   print(await Future.wait(upPostsContent));
  // }
}
