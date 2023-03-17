import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Incompleto y sin probar
class SignUpProvider extends ChangeNotifier{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;
  

  Future signUp (nameController, emailController, passwordController) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController, 
        password: passwordController,
      );
      User newUser = firebaseAuth.currentUser!;
      newUser.updateDisplayName(nameController);
      //Guardar en base de datos
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }
}