import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/drawer.dart';
import 'home/home.dart';
import 'map/map.dart';
import 'notifications/notifications.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentPage = 0;
  //Here goes the views Pages Home(), Map(), Profile(), etc.
  List<Widget> pages = const [
    HomePage(),
    MapPageProvider(),
    NotificationsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Sidebar
      //Ingonar la recomendación de hacer constante el componente ya que contiene elementos que van a cambiar
      drawer: Drawer(child: DrawerComponent()),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Zona Hub"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //Search logic
            },
          )
        ],
      ),
      body: pages[currentPage],

      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 60,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_pin),
            label: 'Maps',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
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
