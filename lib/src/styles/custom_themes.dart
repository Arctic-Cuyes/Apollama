//Dark theme and light theme customization
import 'package:flutter/material.dart';

const Color mainColor = Color.fromARGB(255, 210, 91, 55);

ThemeData customDarkTheme () {
  return  ThemeData.dark().copyWith(
      // Barra de navegación de la parte inferior de la app (home, maps, notificaciones)
      navigationBarTheme:  const NavigationBarThemeData(indicatorColor: mainColor),
      //Barra en la parte superior de la página home (recientes, popular, noticias)
      tabBarTheme: const TabBarTheme(
        indicatorColor: mainColor, 
        labelColor: mainColor,
        unselectedLabelColor: Colors.white38,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(color: mainColor, width: 2.0)),
        indicatorSize: TabBarIndicatorSize.label
      ),
      //Botón "(+)" en página home
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: mainColor)
  );
}

ThemeData customLightTheme(){
  return ThemeData(primarySwatch: Colors.deepOrange).copyWith(
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Colors.white54,
      indicatorSize: TabBarIndicatorSize.label
    )
  );
}
