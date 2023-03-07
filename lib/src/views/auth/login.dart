import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zona_hub/src/views/auth/auth_controller.dart';

import '../root.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthController _controller = AuthController();
  late String? loginToken;
  bool isLoading = true;

  Future<void> _autoRedirectIfLogged() async {
    //TODO: Get login token
    loginToken = await _controller.getSavedSession();
    if (loginToken != null) {
      _goHome();
    }

    setState(() => isLoading = false);
  }

  void _goHome() {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => Root(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _autoRedirectIfLogged());
  }

  Widget _showLogin() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Fake Login"),
        ElevatedButton(
          onPressed: () => _goHome(),
          child: const Text("Login"),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text("Register"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: _showLogin(),
      )),
    );
  }
}
