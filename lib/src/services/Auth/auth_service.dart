import 'package:firebase_auth/firebase_auth.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/user_service.dart';

class AuthService {
  final currentUser = FirebaseAuth.instance.currentUser;
  final UserService userService = UserService();

  Future<UserModel> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final UserModel userModel = await userService.getUserById(user!.uid);
    return userModel;
  }
}
