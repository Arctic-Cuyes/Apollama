import 'package:firebase_auth/firebase_auth.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/user_service.dart';

class AuthService {
  final currentUser = FirebaseAuth.instance.currentUser!;

   saveUserInFirestore(newUser, {name = "User", photoURL}){
    UserModel user = UserModel(
        id: newUser.uid,
        name: newUser.displayName ?? name, 
        email: newUser.email!,
        avatarUrl: photoURL ?? newUser.photoURL,
        createdAt: DateTime.now().toString(),
      );
      UserService().createUser(user);
  }

}

