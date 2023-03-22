import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class AuthMethods {
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
    try {
      final LoginResult result = await facebookAuth
          .login(permissions: ["public_profile", "email", "user_friends"]);

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        //Iniciar sesión en firebase auth
        final User user = (await firebaseAuth.signInWithCredential(credential)).user!;
        
        if (!await UserService().userExistsById(user.uid)) {
          //Solo la primera vez, se instancia FacebookAuth para obtener url de la imagen y guardarla 
          final userData = await facebookAuth.getUserData();
          await user.updatePhotoURL(userData['picture']['data']['url']);
          AuthService().saveUserInFirestore(user);
        }
        _hasError = false;
        debugPrint("foto ->>>>>>>>>>> ${user.providerData}");
      } else {
        _hasError = true;
        _errorCode = "No se pudo autenticar con Facebook";
      }
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
    } on Exception catch (_) {
      _hasError = true;
      _errorCode = "Algo salió mal";
    }
  }

  //Sign in with Google
  Future signInWithGoogle() async {
    //Excepción al cancelar signIn solo se lanza en depuración
    //https://stackoverflow.com/questions/51914691/flutter-platform-exception-upon-cancelling-google-sign-in-flow
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleAuth.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        //Obteniendo usuario
        final User user =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //Guardar en firestore database si no existe
        if (!await UserService().userExistsById(user.uid)) {
          AuthService().saveUserInFirestore(user);
        }
        _hasError = false;
      } else {
        _hasError = true;
        _errorCode = "Inicio de sesiòn cancelado";
      }
    } on FirebaseAuthException catch (e) {
      _errorCode = e.code;
      _hasError = true;
    }
  }

  //Sign in with Email and password
  Future signInWithEmail(emailController, passwordController) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _hasError = false;
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
    }
  }

  //Sign Up with Email and Password
  Future signUp(nameController, emailController, passwordController) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User newUser = userCredential.user!;
      
      await newUser.updateDisplayName(nameController.text.trim());
      //foto por defecto
      await newUser.updatePhotoURL("https://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png");
  
      //Guardar en base de datos
      
       if(!await UserService().userExistsById(newUser.uid)){
          AuthService().saveUserInFirestore(
            newUser, 
            name: nameController.text.trim(),
            photoURL: "https://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png",
          );
        }

      _hasError = false;
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
    }
  }

  //signOut
  Future userSignOut() async {
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
    await googleAuth.signOut();
  }
}
