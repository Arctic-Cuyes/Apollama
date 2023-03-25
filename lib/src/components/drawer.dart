import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zona_hub/src/app.dart';
import 'package:zona_hub/src/services/Auth/auth_methods.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/views/auth/welcome.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

/*
  Sidebar that contains summary profile information and other
  options such as logout, saved posts, profile, configurations, etc.
*/



class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 4, 15, 0),
          child: Column(
            children: [
              // Profile summary and dark mode icon
              Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileSummary(),
                    //Theme mode icon
                    IconButton(
                      onPressed: () {
                        MyApp.themeNotifier.value =
                            (MyApp.themeNotifier.value == ThemeMode.light)
                                ? ThemeMode.dark
                                : ThemeMode.light;
                      },
                      icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.dark_mode
                      ),
                    ),
                  ]
                ),
                const Divider(color: Colors.grey, thickness: 1,),
                //Options
                DrawerOptions()
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSummary extends StatefulWidget {
  const ProfileSummary({super.key});

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> { 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Flex(
        direction: Axis.vertical, 
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
        //User image in circle shape
        GestureDetector(
          onTap: (){
            //Go to profile main page
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(usuario: AuthService().getCurrentUser(), userID: AuthService().currentUser.uid,)));
          },
          child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                  child: Image.network(
                  AuthService().currentUser.photoURL!,
                  // "https://scontent.ftru2-1.fna.fbcdn.net/v/t1.6435-9/95334288_2379795025645267_8549237212774924288_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeH9Yr7NO0GvGYzZs4nmNUaSZpnloegd8HxmmeWh6B3wfKr5TlDQPR9eKDnXfgpi5nnGivH-coVchBzoiU5ttBkW&_nc_ohc=GftqGLKnLkgAX88Bvus&_nc_ht=scontent.ftru2-1.fna&oh=00_AfCSUbFMJOIjD01Ka0lVGCeLnq9rj-pTgK6wxnK6mcrAiQ&oe=64433515",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              )
          ),
        ),
        //User name
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            AuthService().currentUser.displayName ?? "User",
            textAlign: TextAlign.center, 
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(AuthService().currentUser.email!),
      ]),
    );
  }
}

class DrawerOptions extends StatefulWidget {
  const DrawerOptions({super.key});

  @override
  State<DrawerOptions> createState() => _DrawerOptionsState();
}

class _DrawerOptionsState extends State<DrawerOptions> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    List<Map<String, dynamic>> options = [
      {'icon': const Icon(Icons.person_2_rounded), 'option': 'Perfil', 'page': ProfilePage(usuario: authService.getCurrentUser(), userID: authService.currentUser.uid,)},
      {'icon': const Icon(Icons.settings), 'option': 'Configuración', 'page': ProfilePage(usuario: authService.getCurrentUser(), userID: authService.currentUser.uid,) },
      {'icon': const Icon(Icons.bookmark), 'option': 'Guardados', 'page': ProfilePage(usuario: authService.getCurrentUser(), userID: authService.currentUser.uid,)},
      {'icon': const Icon(Icons.logout), 'option': 'Cerrar sesión',},
    ];

    final auth = AuthMethods();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(options[index]['option']),
          leading: options[index]['icon'],
          onTap: () {
            //Lógica para abrir página de opción seleccionada
            if (index == 3) {
              //Logout
              auth.userSignOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeView()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => options[index]['page']));
            }
          },
        );
      },
    );
  }
}
