import 'package:flutter/material.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final String userID;
  final Future<UserModel> usuario;
  const ProfilePage({super.key, required this.usuario, required this.userID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  bool isMyProfile = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('es');
    checkIsMyProfile();
  }

  checkIsMyProfile () async{
    await authService.isThisUserTheCurrentUser(widget.userID).then((value) {
      setState(() {
        isMyProfile = value;
      });
    });
  }

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
            tooltip: "Buscar publicaciones", // Busca publicaciones del perfil de usuario seleccionado
            onPressed: (){}, 
            icon: const Icon(Icons.search)
          ),
          //Reportar perfil (solo se mostrará en perfil != auth.user)
          Offstage(
            offstage: isMyProfile,
            child: IconButton(
              tooltip: "Reportar usuario",
              onPressed: (){}, 
              icon: const Icon(Icons.info)
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: widget.usuario,
        builder: (context, snapshot){
          if (snapshot.hasData){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //photo, name and email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipOval(
                              child: 
                                  Image.network(
                                  snapshot.data!.avatarUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  ),
                            ),
                            const Positioned(
                              bottom: 0,
                              left: 0,
                              child: Icon(Icons.add_a_photo,)
                            )
                            ]
                          ),
                          
                          const SizedBox(height: 10,),
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          //const SizedBox(height: 10,),
                          Text(snapshot.data!.email), // El usuario decide si mostrar o no el email
            
                        ],
                      ),
                      //EDITAR PERFIL
                      Offstage(
                        offstage: !isMyProfile,
                        child: TextButton.icon(
                          onPressed: (){
                      
                          }, 
                          icon: const Icon(Icons.edit, size: 20,),
                          label: const Text("Editar perfil")
                        ),
                      )
                    ]
                  ),
                  //Información extra: fecha de creación de perfil, ubicación, 
                    //UBICACIÓN
                  const SizedBox(height: 15,), 
                  ExtraInfo(
                    icon: const Icon(Icons.my_location), 
                    text: snapshot.data!.location.toString()
                  ),
                    //FECHA DE REGISTRO
                  ExtraInfo(
                    icon: const Icon(Icons.waving_hand_outlined), 
                    text: "Se unió el ${DateFormat("d 'de' MMMM 'del' yyyy").format(DateFormat('dd-MM-yyyy hh:mm:ss').parse(snapshot.data!.createdAt!))}",
                  ),
                    //NUMERO DE COMUNIDADES
                
                  Row(
                    children: const  [
                      ExtraInfo(
                      icon: Icon(Icons.public), 
                      text: "Comunidades 10"
                      ),
                      SizedBox(width: 10,),
                      ExtraInfo(
                        icon: Icon(Icons.post_add), 
                        text: "Publicaciones 1000")
                    ]
                  ),
                  const Divider(),
                  //MIS PUBLICACIONES
                  const Text("Mis publicaciones"),

                ]
              ),
            );
          }else{
            return Container();
          }
        } 
      ),
    );
  }
}

class ExtraInfo extends StatefulWidget {
  
  final Icon icon;
  final String text;

  const ExtraInfo({super.key, required this.icon, required this.text});
  

  @override
  State<ExtraInfo> createState() => _ExtraInfoState();
}

class _ExtraInfoState extends State<ExtraInfo> {
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.text == "null",
      child: Row(
        children: [
          widget.icon,
          Text(
            " ${widget.text}",
          ),
        ],
      ),
    );
  }
}