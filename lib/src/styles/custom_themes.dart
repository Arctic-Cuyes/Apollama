//Dark theme and light theme customization
import 'package:flutter/material.dart';
import 'package:zona_hub/src/styles/global.colors.dart';

const Color mainColorDark = Colors.amber;

const MaterialColor mainColorLight = Colors.amber;

ThemeData customDarkTheme() {
  return ThemeData.dark().copyWith(
    // Barra de navegación de la parte inferior de la app (home, maps, notificaciones)
    navigationBarTheme:
        const NavigationBarThemeData(indicatorColor: mainColorDark),
    //Barra en la parte superior de la página home (recientes, popular, noticias)
    tabBarTheme:  TabBarTheme(
        indicatorColor: mainColorDark,
        labelColor: GlobalColors.lightMainColor,
        unselectedLabelColor: Colors.grey,
        indicator:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white.withOpacity(0.1),
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        indicatorSize: TabBarIndicatorSize.tab),
        
    //Botón "(+)" en página home
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: GlobalColors.mainColor),
    //Loaders
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: GlobalColors.mainColor),
  );
}

ThemeData customLightTheme() {
  return ThemeData(primarySwatch: mainColorLight).copyWith(
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.grey,
      labelColor: GlobalColors.blackColor,
      indicator: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: GlobalColors.mainColor.withOpacity(0.1),
      ),
      indicatorColor: GlobalColors.mainColor,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: GlobalColors.mainColor,
      foregroundColor: Colors.white
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: GlobalColors.mainColor),
  );
}
