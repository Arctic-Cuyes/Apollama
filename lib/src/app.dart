import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:zona_hub/src/styles/custom_themes.dart';
import 'package:zona_hub/src/views/auth/login.dart';
import 'package:zona_hub/src/views/root.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Initial theme mode is the system theme mode
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
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
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot ){
                if(snapshot.hasData){
                  return Root();
                }else{
                  return LoginPage();
                }
              },
            ),
          );
        });
  }
}
