import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/models/user_model.dart';
//Incompleto y sin probar
class SignUpProvider extends ChangeNotifier{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserService userService = UserService();

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
      await newUser.updateDisplayName(nameController.text.trim());
  
      //Guardar en base de datos
      UserModel user = UserModel(
        id: newUser.uid,
        name: nameController.text.trim(), 
        email: newUser.email!,
        createdAt: DateTime.now().toString(),
      );
      userService.createUser(user).catchError(
        (e) {debugPrint("Firestore database error: ${e.toString()}");}
      );
      
      _hasError = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }
}