import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zona_hub/src/services/Auth/auth_controller.dart';

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
                onPressed: () => signIn(_emailController, _passwordController),
                child: const Text("Login"),
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text("Register"),
              ),
              
              Row(
                children: [
                  Image.network("https://cdn-icons-png.flaticon.com/512/61/61045.png", width: 50,)
                ],
              )
            ],
            ),
          ),
        )
      ),
    );
  }

  
}

