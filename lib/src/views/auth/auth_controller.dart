import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  late String? loginToken;

  Future<String?> getSavedSession() async {
    //TODO: get token from LOCAL storage/db.
    loginToken = null; //colocar un string cualquiera y se inicia sesión solo.s
    return loginToken;
  }
}
