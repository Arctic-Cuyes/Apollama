import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/services/Auth/sign_in_provider.dart';
import 'package:zona_hub/src/styles/custom_themes.dart';
import 'package:zona_hub/src/views/auth/login.dart';
import 'package:zona_hub/src/views/root.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
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
            home: sp.isSignedIn == true ? Root() : LoginPage(),
          );
        });
  }
}