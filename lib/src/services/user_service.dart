import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/tag_service.dart';

class UserService {
  final usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (snapshots, _) =>
                UserModel.fromJson(snapshots.data() as Map<String, dynamic>),
            toFirestore: (user, _) => user.toJson(),
          );
  final TagService tagService = TagService();
  
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

  //Update only user name
  Future<void> updateUserName(String newName) async {
    User currentUser = AuthService().currentUser;
    await currentUser.updateDisplayName(newName);
    await usersRef.doc(currentUser.uid).update({'name': newName});
  }

  //Update only userAvatar
  Future<void> updateUserAvatar(String avatarURL) async {
    User currentUser = AuthService().currentUser;
    await currentUser.updatePhotoURL(avatarURL);
    await usersRef.doc(currentUser.uid).update({'avatarUrl': avatarURL});
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

  // up vote post
  Future<void> upVotePost(UserModel user, Post post) async {
    // add post to user's upvoted posts
    user.upPosts?.add(post.toDocumentReference());
    // update user
    await usersRef.doc(user.id).update({
      'upPosts': user.upPosts,
    });
  }

  // remove upvote from post
  Future<void> removeUpVotePost(UserModel user, Post post) async {
    // remove post from user's upvoted posts
    user.upPosts?.remove(post.toDocumentReference());
    // update user
    await usersRef.doc(user.id).update({
      'upPosts': user.upPosts,
    });
  }

  // down vote post
  Future<void> downVotePost(UserModel user, Post post) async {
    // add post to user's downvoted posts
    user.downPosts?.add(post.toDocumentReference());
    // update user
    await usersRef.doc(user.id).update({
      'downPosts': user.downPosts,
    });
  }

  // remove downvote from post
  Future<void> removeDownVotePost(UserModel user, Post post) async {
    // remove post from user's downvoted posts
    user.downPosts?.remove(post.toDocumentReference());
    // update user
    await usersRef.doc(user.id).update({
      'downPosts': user.downPosts,
    });
  }

  // get user's reacted posts by user id
  Stream<List<Post>> getUserReactedPosts(String userId) {
    return usersRef.doc(userId).snapshots().asyncMap((snapshot) async {
      UserModel user = snapshot.data() as UserModel;
      List<Post> posts = await Future.wait(user.upPosts!.map((postRef) async {
        DocumentSnapshot postSnapshot = await postRef.get();
        Post post = Post.fromJson(postSnapshot.data() as Map<String, dynamic>);
        post.id = postSnapshot.id;
        post.authorData = await getUserDataFromDocRef(post.author!);
        post.tagsData = await tagService.getTagsFromDocRefList(post.tags!);
        post.authorData!.id = post.author!.id;
        return post;
      }));
      return posts;
    });
  }
}
