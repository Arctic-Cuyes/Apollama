import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart'; 

Future signIn (emailController, passwordController) async{
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(), 
      password: passwordController.text.trim(),
  );
}