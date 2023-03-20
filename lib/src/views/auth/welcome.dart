import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/global/button.dart';
import 'package:zona_hub/src/constants/images.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/views/auth/screens/login_screen.dart';
import 'package:zona_hub/src/views/auth/screens/register_screen.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  void showLoginBottomSheet() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: GlobalColors.whiteColor,
      builder: (context) => DraggableScrollableSheet(
        expand: false,

        maxChildSize: 0.7,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Container(
            child: LoginScreen(),
          )
        ),
      )
    );
  }

  void showRegisterBottomSheet() {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: GlobalColors.whiteColor,
      builder: (context) => DraggableScrollableSheet(
        expand: false,

        maxChildSize: 0.8,
        initialChildSize: 0.7,
        minChildSize: 0.6,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Container(
            child: RegisterScreen(),
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      resizeToAvoidBottomInset: false,
      backgroundColor: GlobalColors.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(image: AssetImage(GlobalConstansImages.urlLogo), width: 100,),
            const SizedBox(height: 20.0),
            const Text(
              "Zona Hub",
              style: TextStyle(
                color: GlobalColors.blackColor,
                fontSize: 40.0,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 10.0),
            // Text Color Black
            const Text(
              "Bienvenido!",
              style: TextStyle(
                color: GlobalColors.blackColor,
                fontSize: 20.0,
              ),
            ),

            const SizedBox(height: 100.0),
            // Log in
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              constraints: const BoxConstraints(maxWidth: 500.0),
              child: ButtonPrincipal(
                text: "Iniciar Sesión",
                onPressed: () {
                  showLoginBottomSheet();
                },
              ),
            ),

            

            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              constraints: const BoxConstraints(maxWidth: 500.0),
              child: ButtonPrincipal(
                text: "Registrarse",
                onPressed: () {
                  showRegisterBottomSheet();
                },
                showBorders: true,
              ),
            ),

        
          
          ],
        ),
      ),
   
    );
  }

  
}

