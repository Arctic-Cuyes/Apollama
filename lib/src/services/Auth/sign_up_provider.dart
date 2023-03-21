import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
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
      await newUser.updateDisplayName(nameController.text.trim());
  
      //Guardar en base de datos
      
       if(!await UserService().userExistsById(newUser.uid)){
          AuthService().saveUserInFirestore(newUser);
        }

      _hasError = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }
}
