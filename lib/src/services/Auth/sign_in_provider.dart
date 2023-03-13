import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier{
  
  //Instancias 
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  //Google instance
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

  //sign in with facebook
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
        debugPrint("Datos de usuario login facebook $_email - $imageURL");
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        debugPrint(e.code.toString());
        _hasError = true;
        _errorCode = e.code;
        notifyListeners();
      }
    }else{
      _hasError = true;
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