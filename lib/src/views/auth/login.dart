import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 4,),
              TextField(
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              
              const SizedBox(height: 4,),
          
              ElevatedButton(
                onPressed: () => _signIn(),
                child: const Text("Login"),
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text("Register"),
              )
            ],
            ),
          ),
        )
      ),
    );
  }

  Future _signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
    );
  }
}

