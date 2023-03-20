import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: "Atrás",
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back,),
        ),
        //AppBar buttons
        actions: [
          //Buscar mis publicaciones
          IconButton(
            tooltip: "Buscar mis publicaciones",
            onPressed: (){}, 
            icon: const Icon(Icons.search)
          ),
          //Reportar perfil (solo se mostrará en perfil != auth.user)
          IconButton(
            tooltip: "Reportar usuario",
            onPressed: (){}, 
            icon: const Icon(Icons.info)
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                
              ]
            ),
          ]
        ),
      ),
    );
  }
}