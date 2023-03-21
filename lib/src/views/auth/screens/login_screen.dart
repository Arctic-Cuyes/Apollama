import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/forms/pages_login.dart';
import 'package:zona_hub/src/components/forms/text_field.dart';
import 'package:zona_hub/src/components/global/button.dart';
import 'package:zona_hub/src/components/warnings/snackbar.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/services/Auth/sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/views/root.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // NOTA: Lo he puesto para probar xd
  final _emailController = TextEditingController(
    text: "arcticcuyes@gmail.com" 
  );
  final _passwordController = TextEditingController(
    text: "arcticcuyes"
  );

  String _texto = "Iniciar Sesión";

  
 void handleEmailSignIn()async{
    openDialogLoader();
    final sp = context.read<SignInProvider>();
    sp.signInWithEmail(_emailController, _passwordController).then((value) {
      if (sp.hasError == true) {
        Navigator.of(context).pop(); // Close loader 
        _texto = "Iniciar Sesión";
        showSnackBar(context: context, text: sp.errorCode!);
      }else{
        sp.setSignIn().then((value){
          handleAfterSignIn();
        });
      }
    });
  }
  //Puede ir en utils
  openDialogLoader(){
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_){
        return const Center(child: CircularProgressIndicator(),);
      }
    );
  }
  handleAfterSignIn(){
    Navigator.of(context).pop(); // Close loader 
    // Go to root page
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Root()));
  }

 

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30
            ),
            child: Column(
              children: [
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 25,
                    color: GlobalColors.blackColor,
                    fontWeight: FontWeight.bold,
                  )
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
                    setState(() {
                      _texto = "Conectando...";
                    });
                    handleEmailSignIn();
                  }
                ),
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
          )
        );
  }
}