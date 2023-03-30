import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zona_hub/src/styles/custom_themes.dart';
import 'package:zona_hub/src/views/auth/welcome.dart';
import 'package:zona_hub/src/views/root.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Apollama',
            //Customize light theme
            theme: customLightTheme(),
            //Customize dark theme with primarySwatch amber
            darkTheme: customDarkTheme(),
            themeMode: currentMode,
            home: FutureBuilder(
                future: FirebaseAuth.instance.authStateChanges().first,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Root();
                  } else {
                    return WelcomeView();
                  }
                }));
      },
    );
  }
}
