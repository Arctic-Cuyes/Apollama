import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/app.dart';
import 'package:zona_hub/src/services/Auth/sign_in_provider.dart';
import 'package:zona_hub/src/views/auth/login.dart';
import 'package:zona_hub/src/views/auth/welcome.dart';
import 'package:zona_hub/src/views/profile/profile.dart';
import 'package:zona_hub/src/views/root.dart';

/*
  Sidebar that contains summary profile information and other
  options such as logout, saved posts, profile, configurations, etc.
*/

const List<Map<String, dynamic>> options = [
  {'icon': Icon(Icons.person_2_rounded), 'option': 'Perfil', 'page': ProfilePage()},
  {'icon': Icon(Icons.settings), 'option': 'Configuración', 'page': ProfilePage() },
  {'icon': Icon(Icons.edit), 'option': 'Editar elemento', 'page': ProfilePage()},
  {'icon': Icon(Icons.logout), 'option': 'Cerrar sesión',},
];

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              const DrawerOptions()
          ],
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                  child: Image.network(
                  //Cambiará según la base de datos, por el momento una imagen de internet
                  Root.user.imageURL!,
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
            Root.user.name!,
            textAlign: TextAlign.center, 
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text("+51 123 456 789"),
        Text(Root.user.email!),
      ]),
    );
  }
}

// List of Options
class DrawerOptions extends StatelessWidget {
  const DrawerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(options[index]['option']),
        leading: options[index]['icon'],
        onTap: (){
          //Lógica para abrir página de opción seleccionada
          if(index == 3){ //Logout
            sp.userSignOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeView()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => options[index]['page']));
          }
        },
        );
      },
    );
  }
}
