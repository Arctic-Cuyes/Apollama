import 'package:firebase_auth/firebase_auth.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/user_service.dart';

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

  saveUserInFirestore(newUser, {name = "User"}) async {
    UserModel user = UserModel(
      id: newUser.uid,
      name: newUser.displayName ?? name,
      email: newUser.email!,
      createdAt: DateTime.now().toString(),
    );
    await UserService().createUser(user);
  }
}
