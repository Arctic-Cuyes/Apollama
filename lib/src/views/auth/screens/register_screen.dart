import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/forms/pages_login.dart';
import 'package:zona_hub/src/components/forms/text_field.dart';
import 'package:zona_hub/src/components/global/button.dart';
import 'package:zona_hub/src/components/warnings/snackbar.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/services/Auth/auth_methods.dart';
import 'package:zona_hub/src/views/root.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController(text: "");

  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");

  String _texto = "Registrarse";
  final auth = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: GlobalColors.whiteColor,
      child: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            const Text("Registrarse",
                style: TextStyle(
                  fontSize: 25,
                  color: GlobalColors.blackColor,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20.0),
            buildTextField(
              obscureText: false,
              controller: _nameController,
              hintText: "Nombre de Usuario",
              prefixedIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 20.0),
            buildTextField(
              obscureText: false,
              controller: _emailController,
              hintText: "Correo Electrónico",
              prefixedIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 10.0),
            buildTextField(
              obscureText: true,
              controller: _passwordController,
              hintText: "Contraseña",
              prefixedIcon: const Icon(Icons.lock),
            ),
            const SizedBox(height: 10.0),
            ButtonPrincipal(
                text: _texto,
                onPressed: () {
                  openDialogLoader();
                  auth.signUp(_nameController, _emailController, _passwordController).then((value) {
                    if (auth.hasError) {
                      //Errores de registro por ej: email ya registrado, contraseña débil, etc.
                      showSnackBar(
                          context: context,
                          text: "Error de registro ${auth.errorCode}");
                      _texto = "Registrarse";
                      Navigator.of(context).pop(); // close loader
                    } else {
                      handleEmailSignIn();
                    }
                  });
                  setState(() {
                    _texto = "Conectando...";
                  });
                }),
            // const SizedBox(height: 30.0),
            // const Row(
            //   children: [
            //     Text(
            //       "¿Aún no tienes cuenta?",
            //       style: TextStyle(
            //         fontSize: 15,
            //         color: GlobalColors.blackColor,
            //         fontWeight: FontWeight.w600,
            //       )
            //     ),
            //   ],
            // ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 1,
                  color: Colors.black,
                ),
                const Text(
                  "  O  ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                Container(
                  width: 60,
                  height: 1,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            PagesLogin()
          ],
        ),
      )),
    );
  }

  void handleEmailSignIn() async {
    // final auth = SignInProvider();
    auth.signInWithEmail(_emailController, _passwordController).then((value) {
      if (auth.hasError == true) {
        Navigator.of(context).pop(); // Close loader
        _texto = "Registrarse";
        showSnackBar(context: context, text: auth.errorCode!);
      } else {
        handleAfterSignIn();
      }
    });
  }

  //Puede ir en utils
  openDialogLoader() {
    showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  handleAfterSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Root()),
      (route) => false,
    );
  }
}
