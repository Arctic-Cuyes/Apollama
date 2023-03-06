//Dark theme and light theme customization
import 'package:flutter/material.dart';

ThemeData customDarkTheme () {
  return  ThemeData.dark().copyWith(
      // Barra de navegación de la parte inferior de la app (home, maps, notificaciones)
      navigationBarTheme:  const NavigationBarThemeData(indicatorColor: Colors.amber),
      //Barra en la parte superior de la página home (recientes, popular, noticias)
      tabBarTheme: const TabBarTheme(
        indicatorColor: Colors.amber, 
        unselectedLabelColor: Colors.white38,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.amber, width: 1.0))
      ),
      //Botón "(+)" en página home
      floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.amber)
  );
}

ThemeData customLightTheme(){
  return ThemeData(primarySwatch: Colors.amber).copyWith(
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Colors.black38,
      indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.black, width: 1.0))
    )
  );
}
