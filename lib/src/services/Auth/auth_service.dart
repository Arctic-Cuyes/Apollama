import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final currentUser = FirebaseAuth.instance.currentUser;
}
