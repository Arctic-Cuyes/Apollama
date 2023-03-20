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
    debugPrint("Email: ${emailController.text.toString()}");
    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
      User newUser = userCredential.user!;
      newUser.updateDisplayName(nameController.text.trim());
      //Guardar en base de datos
      _hasError = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }
}