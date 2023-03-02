import 'package:flutter/material.dart';
import 'package:zona_hub/src/views/home/home.dart';
import 'package:zona_hub/src/views/map/map.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Initial theme mode is the system theme mode
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZonaHub',
          //Customize light theme
          theme: ThemeData(primarySwatch: Colors.red,),
          //Customize darak theme
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          
          home: Root(),
        );
      } 
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  int currentPage = 0;
  //Here goes the views Pages Home(), Map(), Profile(), etc.
  List<Widget> pages = const [HomePage(), ProfilePage(), MapPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zona Hub"),
        actions: [
          IconButton(
            icon: Icon( MyApp.themeNotifier.value == ThemeMode.light ? Icons.light_mode : Icons.dark_mode), 
            onPressed: () {
              //Change the theme mode
              MyApp.themeNotifier.value = (MyApp.themeNotifier.value == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;  
            },)
        ],
      ),
      body: pages[currentPage],
    
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.person_2), label: "Profiles"),
          NavigationDestination(icon: Icon(Icons.map), label: "Map")
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}


// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
  
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // Initial theme mode is the system theme mode
//   static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
  
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<ThemeMode>(
//       valueListenable: themeNotifier,
//       builder: (context, currentMode, _) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'ZonaHub',
//           theme: ThemeData(primarySwatch: Colors.amber),
//           darkTheme: ThemeData.dark(),
//           themeMode: currentMode,
//           home: const Scaffold(),
//         );
//       } 
//     );

//   }
// }