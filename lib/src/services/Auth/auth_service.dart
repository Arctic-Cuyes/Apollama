import 'package:firebase_auth/firebase_auth.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/user_service.dart';

class AuthService {
  final currentUser = FirebaseAuth.instance.currentUser!;

   saveUserInFirestore(newUser){
    UserModel user = UserModel(
        id: newUser.uid,
        name: newUser.displayName!, 
        email: newUser.email!,
        createdAt: DateTime.now().toString(),
      );
      UserService().createUser(user);
  }

}

