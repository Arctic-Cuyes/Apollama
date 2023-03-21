import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zona_hub/src/models/user_model.dart';

class UserService {
  final usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (snapshots, _) =>
                UserModel.fromJson(snapshots.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toJson(),
          );

  Future<UserModel> getUserDataFromDocRef(DocumentReference userRef) async {
    DocumentSnapshot userSnapshot = await userRef.get();
    return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
  }

  // create user with an autogenerated id
  Future<void> createUser(UserModel user) async {
    await usersRef.doc(user.id).set(user);
  }

  // create user with a specified id
  Future<void> createUserWithId(UserModel user) async {
    await usersRef.doc(user.id).set(user);
  }

  // update user
  Future<void> updateUser(UserModel user) async {
    await usersRef.doc(user.id).update(user.toJson());
  }

  // delete user
  Future<void> deleteUser(String id) async {
    await usersRef.doc(id).delete();
  }

  // find user by id
  Future<UserModel> getUserById(String id) async {
    DocumentSnapshot userSnapshot = await usersRef.doc(id).get();
    UserModel user = userSnapshot.data() as UserModel;
    user.id = userSnapshot.id;
    return user;
  }

  Future<bool> userExistsById(String id) async {
    DocumentSnapshot userSnapshot = await usersRef.doc(id).get();
    return userSnapshot.data() != null ? true : false;
  }
}
