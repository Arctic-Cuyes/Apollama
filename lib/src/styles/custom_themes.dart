//Dark theme and light theme customization
import 'package:flutter/material.dart';

const Color mainColorDark = Colors.amber;

const MaterialColor  mainColorLight = Colors.amber;

ThemeData customDarkTheme () {
  return  ThemeData.dark().copyWith(
      // Barra de navegación de la parte inferior de la app (home, maps, notificaciones)
      navigationBarTheme:  const NavigationBarThemeData(indicatorColor: mainColorDark),
      //Barra en la parte superior de la página home (recientes, popular, noticias)
      tabBarTheme: const TabBarTheme(
        indicatorColor: mainColorDark, 
        labelColor: mainColorDark,
        unselectedLabelColor: Colors.white38,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(color: mainColorDark, width: 2.0)),
        indicatorSize: TabBarIndicatorSize.label
      ),
      //Botón "(+)" en página home
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: mainColorDark),
      //Loaders 
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: mainColorDark),
  );
}

ThemeData customLightTheme(){
  return ThemeData(primarySwatch: mainColorLight).copyWith(
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.black, width: 2.0)),
      unselectedLabelColor: Colors.white54,
      indicatorSize: TabBarIndicatorSize.label
    )
  );
}
