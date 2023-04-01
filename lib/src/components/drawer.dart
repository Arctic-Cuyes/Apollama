import 'package:flutter/material.dart';
import 'package:zona_hub/src/app.dart';
import 'package:zona_hub/src/services/Auth/auth_methods.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/views/activity/activity.dart';
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
              Stack(
                children: [
                  ProfileSummary(),
                  //Theme mode icon
                  Positioned(
                    top: 10,
                    right: 0,

                    child: IconButton(
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
                  )
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
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        // horizontal: 10,
      ),
      width: double.infinity,
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: GlobalColors.mainColor,
      //     width: 3,
      //   ),
      //   color: GlobalColors.mainColor.withOpacity(0.4),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: Flex(
        direction: Axis.vertical, 
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
        //User image in circle shape
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              //Go to profile main page
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(usuario: AuthService().getCurrentUser(), userID: AuthService().currentUser.uid,)));
            },
            child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GlobalColors.mainColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipOval(
                    child: Image.network(
                    AuthService().currentUser.photoURL!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                )
            ),
          ),
          //User name
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
        ]
      ),

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
      {'icon': const Icon(Icons.access_time_outlined), 'option': 'Actividad', 'page': Activity() },
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
              Navigator.pop(context); // Close drawer
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
