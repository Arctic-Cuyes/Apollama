import 'package:flutter/material.dart';
import 'package:zona_hub/src/app.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

/*
  Sidebar that contains summary profile information and other
  options such as logout, saved posts, profile, configurations, etc.
*/

const List<Map<String, dynamic>> options = [
  {'icon': Icon(Icons.person_2_rounded), 'option': 'Perfil'},
  {'icon': Icon(Icons.settings), 'option': 'Configuración'},
  {'icon': Icon(Icons.edit), 'option': 'Editar elemento'},
  {'icon': Icon(Icons.logout), 'option': 'Cerrar sesión' },
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

class ThemeModeIcon extends StatefulWidget {
  const ThemeModeIcon({super.key});

  @override
  State<ThemeModeIcon> createState() => _ThemeModeIconState();
}

class _ThemeModeIconState extends State<ThemeModeIcon> {
  @override
  Widget build(BuildContext context) {
    return Container();
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
    return SizedBox(
      height: 165,
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
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
                  "https://i.pinimg.com/originals/30/8d/79/308d795c3cac0f8f16610f53df4e1005.jpg",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              )
          ),
        ),
        //User name
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Text(
            "Fogel McLovin", 
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text("+51 123 456 789"),
        const Text("ContactoOpcional@gmail.com")
      ]),
    );
  }
}

// List of Options
class DrawerOptions extends StatelessWidget {
  const DrawerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(options[index]['option']),
        leading: options[index]['icon'],
        onTap: (){
          //Lógica para abrir página seleccionada
          debugPrint((index).toString());
        },
        );
      },
    );
  }
}
