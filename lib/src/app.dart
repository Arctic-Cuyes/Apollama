import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/services/Auth/sign_in_provider.dart';
import 'package:zona_hub/src/styles/custom_themes.dart';
import 'package:zona_hub/src/views/auth/login.dart';
import 'package:zona_hub/src/views/root.dart';
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   // Initial theme mode is the system theme mode
//   static final ValueNotifier<ThemeMode> themeNotifier =
//       ValueNotifier(ThemeMode.system);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//         valueListenable: themeNotifier,
//         builder: (context, currentMode, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'ZonaHub',
//             //Customize light theme
//             theme: customLightTheme(),
//             //Customize dark theme with primarySwatch amber
//             darkTheme: customDarkTheme(),
//             themeMode: currentMode,

//             //IGNORAR RECOMENDACIÓN DE USAR CONST
//             home: StreamBuilder<User?>(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (context, snapshot ){
//                 if(snapshot.hasData){
//                   return Root();
//                 }else{
//                   return LoginPage();
//                 }
//               },
//             ),
//           );
//         });
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isSigned;

  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    sp.addListener(_onSignInProviderChanged); // Agregar un listener a SignInProvider
    //sp.checkSignInUser(); // Verificar la sesión iniciada al cargar la aplicación
    super.initState();
  }

  @override
  void dispose() {
    final sp = context.read<SignInProvider>();
    sp.removeListener(_onSignInProviderChanged); // Eliminar el listener de SignInProvider
    super.dispose();
  }

  void _onSignInProviderChanged() {
    final sp = context.read<SignInProvider>();
    setState(() {
      isSigned = sp.isSignedIn; // Actualizar isSigned cuando _isSignedIn cambie
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: MyApp.themeNotifier,
        builder: (context, currentMode, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ZonaHub',
            //Customize light theme
            theme: customLightTheme(),
            //Customize dark theme with primarySwatch amber
            darkTheme: customDarkTheme(),
            themeMode: currentMode,
          
            //IGNORAR RECOMENDACIÓN DE USAR CONST
            home: isSigned == null ? 
                    const Scaffold(body: Center(child: CircularProgressIndicator())) 
                  : 
                    isSigned == true ? Root() : LoginPage(),
          );
        });
  }
}