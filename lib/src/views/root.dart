import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zona_hub/src/components/drawer.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Internet/connectivity_service.dart';
import 'package:zona_hub/src/views/permissions/permission.dart';
import 'package:zona_hub/src/views/profile/profile.dart';
import 'home/home.dart';
import 'map/map.dart';
import 'notifications/notifications.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  // static SignInProvider user = SignInProvider();

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentPage = 0;
  PermissionStatus? _status;
  late final InternetValidationService _interService;
  late final StreamSubscription<ConnectivityResult> _internetSubscription;
  //Here goes the views Pages Home(), Map(), Profile(), etc.
  List<Widget> pages = const [
    HomePage(),
    MapPageProvider(),
    NotificationsPage()
  ];

  void _requestPermission() async {
    _status = await Permission.locationWhenInUse.status;
    if (_status != PermissionStatus.granted) {
      _goRequestPermission();
    }
  }

  void _goRequestPermission() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const RequestPermissionPage()));
  }

  @override
  void initState() {
    debugPrint("Se construye Root");
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _interService = InternetValidationService();
      _internetSubscription = _interService.subscription.listen((result) {
        _interService.showConnectionSnackbar(context, result);
      });
      _requestPermission();
      AuthService().getCurrentUser();
    });
  }

  

  @override
  void dispose() {
    // TODO: implement dispose
    _internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(AuthService().currentUser.photoURL!,);
    return Scaffold(
      //Sidebar
      //Ingonar la recomendación de hacer constante el componente ya que contiene elementos que van a cambiar
      drawer: Drawer(child: DrawerComponent()),
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Zona Hub"),
        actions: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => 
                    ProfilePage(usuario: 
                      AuthService().getCurrentUser(), 
                      userID: AuthService().currentUser.uid,
                    )
                  )
                )
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                  AuthService().currentUser.photoURL!,
                ),
              ),
            )
            
            
          ),
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
