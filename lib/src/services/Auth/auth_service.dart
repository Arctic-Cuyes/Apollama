import 'package:firebase_auth/firebase_auth.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:intl/intl.dart';

class AuthService {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final UserService userService = UserService();

  Future<UserModel> getCurrentUser() async {
    final UserModel userModel = await userService.getUserById(currentUser.uid);
    return userModel;
  }


  Future<bool> isThisUserTheCurrentUser(String userId) async {
    final user = await getCurrentUser();
    return user.id == userId;
  }

  saveUserInFirestore(newUser, {name = "User", photoURL}){
    UserModel user = UserModel(
        id: newUser.uid,
        name: newUser.displayName ?? name, 
        email: newUser.email!,
        avatarUrl: photoURL ?? newUser.photoURL,
        createdAt: DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now()).toString(),
      );
      UserService().createUser(user);
   }
}
