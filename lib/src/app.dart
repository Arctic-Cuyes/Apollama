import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/drawer.dart';
import 'package:zona_hub/src/views/notifications/notifications.dart';
import 'package:zona_hub/src/views/home/home.dart';
import 'package:zona_hub/src/views/map/map.dart';

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
          theme: ThemeData(primarySwatch: Colors.amber,),
          //Customize darak theme
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          
          home: const Root(),
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
  List<Widget> pages = const [HomePage(), MapPage(), NotificationsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Sidebar
      //Ingonar la recomendación de hacer constante el componente ya que contiene elementos que van a cambiar
      drawer: const Drawer(
        child: DrawerComponent() 
      ),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Zona Hub"),
        actions: [
          IconButton(
            icon: const Icon( Icons.search ), 
            onPressed: () {
              //Search logic 
            },)
        ],
      ),
      body: pages[currentPage],

      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 60,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio',),
          NavigationDestination(icon: Icon(Icons.location_pin), label: 'Maps'),
          NavigationDestination(icon: Icon(Icons.notifications), label: 'Notificaciones'),
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