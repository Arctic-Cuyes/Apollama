import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:zona_hub/src/components/forms/pages_login.dart';
import 'package:zona_hub/src/components/forms/text_field.dart';
import 'package:zona_hub/src/components/global/button.dart';
import 'package:zona_hub/src/components/warnings/snackbar.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/services/Auth/auth_methods.dart';
import 'package:zona_hub/src/utils/flash_error_message.dart';
import 'package:zona_hub/src/utils/forms/firebase_error_code_exceptions.dart';
import 'package:zona_hub/src/utils/forms/regex.dart';
import 'package:zona_hub/src/views/root.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // NOTA: Lo he puesto para probar xd
  final _emailController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  //Auth methods
  final auth = AuthMethods();

  void handleEmailSignIn() async {
    openDialogLoader();
    // final auth = context.read<SignInProvider>();
    auth.signInWithEmail(_emailController, _passwordController).then((value) {
      if (auth.hasError == true) {
        Navigator.of(context).pop(); // Close loader
        print(auth.errorCode);
        // showSnackBar(context: context, text: auth.errorCode!);
        String errorMessage =
            FirebaseErrorCodeExceptions.getMessageFromErrorCode(auth.errorCode);
        ShowError(errorMessage);
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

  ShowError(message) {
    // Close Modal
    // Navigator.of(context).pop();

    FlashMessage.showErrorMessage(message, context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            const Text("Iniciar Sesión",
                style: TextStyle(
                  fontSize: 25,
                  color: GlobalColors.blackColor,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20.0),
            buildTextField(
              obscureText: false,
              controller: _emailController,
              hintText: "Correo Electrónico",
              prefixedIcon: const Icon(Icons.email),
              validator: (value) {
                if (value!.isEmpty) {
                  return "El correo electrónico no puede estar vacío";
                }

                if (!RegexValidator.isValidEmail(value)) {
                  return "No es un correo electrónico válido";
                }

                return null;
              },
            ),
            const SizedBox(height: 10.0),
            buildTextField(
              obscureText: true,
              controller: _passwordController,
              hintText: "Contraseña",
              prefixedIcon: const Icon(Icons.lock),
              validator: (value) {
                if (value!.isEmpty) {
                  return "La contraseña no puede estar vacía";
                }

                return null;
              },
            ),
            const SizedBox(height: 10.0),
            ButtonPrincipal(
                text: "Iniciar Sesión",
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    handleEmailSignIn();
                  }
                }),
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
}
