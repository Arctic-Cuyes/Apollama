import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona_hub/src/components/warnings/snackbar.dart';

class SignInProvider extends ChangeNotifier{
  
  //Instancias 
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleAuth = GoogleSignIn();
  //
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;
  
  String? _provider;
  String? get provider => _provider;
  
  String? _userID;
  String? get userID => _userID;
  
  String? _email;
  String? get email => _email;
  
  String? _name;
  String? get name => _name;
  
  String? _imageURL;
  String? get imageURL => _imageURL;

  SignInProvider(){
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool("signed_in") ?? false; 
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("signed_in", true);
    _isSignedIn = true;
    notifyListeners();
  }
  // Sign in with Facebook, google and email
    //sign in with Facebook
  Future<void> signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login(permissions: ["public_profile", "email", "user_friends"]);
    
    if(result.status == LoginStatus.success){
      try {
        final userData = await facebookAuth.getUserData();
        
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(credential);
        _name = userData['name'];
        _email = userData['email'];
        _imageURL = userData['picture']['data']['url'];
        _userID = userData['id'];
        _hasError = false;
        _provider = "FACEBOOK";
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
        _name = user.displayName ?? "user"; 
        _email = user.email;
        _imageURL = user.photoURL ?? "https://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png";
        _userID = user.uid;
        _hasError = false;
        _provider = "GOOGLE";

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
      final user = firebaseAuth.currentUser!;
      //debugPrint("Post datos de email user: ${user.email} ${user.displayName} ${user.photoURL} $_userID");
      _name = user.displayName ?? "user"; 
      _email = user.email;
      _imageURL = user.photoURL ?? "https://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png";
      _userID = user.uid;
      _hasError = false;
      _provider = "EMAIL";
      //debugPrint("Datos de email user: $_name $_email $_imageURL $_userID");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
    
  }

  //Save data to shared preferences
  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('name', _name!);
    await sp.setString('email', _email!);
    await sp.setString('imageURL', _imageURL!);
    await sp.setString('provider', _provider!);  
    notifyListeners();
  }
  Future getDataFromSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _email = sp.getString('email');
    _imageURL = sp.getString('imageURL');
    _provider = sp.getString("provider");
    notifyListeners();  
  }
  //signOut
  Future userSignOut() async {
    await firebaseAuth.signOut();
    await facebookAuth.logOut();
    await googleAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    clearSotredData();
  }

  //

  //clear data
  Future clearSotredData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}