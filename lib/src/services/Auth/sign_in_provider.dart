import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class SignInProvider extends ChangeNotifier{
  
  //Instancias 
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleAuth = GoogleSignIn();

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  // Sign in with Facebook, google and email
    //sign in with Facebook
  Future<void> signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login(permissions: ["public_profile", "email", "user_friends"]);
    
    if(result.status == LoginStatus.success){
      try {
        //final userData = await facebookAuth.getUserData();
        
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        final User user  = (await firebaseAuth.signInWithCredential(credential)).user!;
          
        if(!await UserService().userExistsById(user.uid)){
          AuthService().saveUserInFirestore(user);
        }
        _hasError = false;
        notifyListeners(); 
      } on FirebaseAuthException catch (e) {
        _hasError = true;
        _errorCode = e.code;
        notifyListeners();
      }
    }else{
      _hasError = true;
      notifyListeners();
    }
  }
    //Sign in with Google
  Future signInWithGoogle() async { 
    //Excepción al cancelar signIn solo se lanza en depuración 
    //https://stackoverflow.com/questions/51914691/flutter-platform-exception-upon-cancelling-google-sign-in-flow
    final GoogleSignInAccount? googleSignInAccount = await googleAuth.signIn().catchError((e){
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }); 
    if (googleSignInAccount != null){
      try {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        
        final AuthCredential credential = 
          GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken
          );
        
        final User user  = (await firebaseAuth.signInWithCredential(credential)).user!;
        
      
        if(!await UserService().userExistsById(user.uid)){
          AuthService().saveUserInFirestore(user);
        }
        _hasError = false;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        _errorCode = e.code;
        notifyListeners();
      }
    }else{
      _hasError = true;
      _errorCode = "Inicio de sesiòn cancelado";
      notifyListeners();
    }
  }
    //Sign in with Email and password
  Future signInWithEmail (emailController, passwordController) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
  
      _hasError = false;
      
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
    
  }

  //signOut
  Future userSignOut() async {
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
    await googleAuth.signOut();
  }
}