import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zona_hub/src/app.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Storage/firebase_storage.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/views/profile/interactions.dart';
import 'package:zona_hub/src/views/profile/posts.dart';


String? newImage;
String? newName;

final _formKey = GlobalKey<FormState>();

class ProfilePage extends StatefulWidget {
  final String userID;
  final Future<UserModel> usuario;
  const ProfilePage({super.key, required this.usuario, required this.userID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final AuthService authService = AuthService();
  final Storage storage = Storage();
  late TabController _tabBarController;
  bool isMyProfile = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('es');
    checkIsMyProfile();
    _tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    newImage = null;
    super.dispose();
  }

  checkIsMyProfile() async {
    await authService.isThisUserTheCurrentUser(widget.userID).then((value) {
      setState(() {
        isMyProfile = value;
      });
    });
  }

  openProfilePhoto(String url){
    showDialog(
      context: context, 
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          alignment: Alignment.topLeft,
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Image.network(
              url,
              width: 320,
              height: 320,
              fit: BoxFit.cover,
            ),
            ),
        );
      } 
    );
  }

  openUpdatePhotoOptions(){
    showModalBottomSheet(
      context: context, 
      constraints: const  BoxConstraints(
        maxHeight: 120,
      ),
      builder: (_){
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title:  const Text("Tomar Foto"),
              onTap: () => storage.getImageURL(ImageSource.camera).then((value) {
                if(value != "0"){
                  setState(() {
                    newImage = value;
                  });
                  storage.updateProfilePhoto(value);
                }
                
              }),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Subir desde galería"),
              onTap: () => storage.getImageURL(ImageSource.gallery).then((value) {
                if(value != "0"){
                  setState(() {
                    newImage = value;
                  });
                  storage.updateProfilePhoto(value);
                }
              }),
            ),
          ],
        );
      }
    );
  }

  openEditNameForm(){
    TextEditingController nameController = TextEditingController(text: newName ?? authService.currentUser.displayName);

    showModalBottomSheet(
      context: context, 
      
      builder: (_){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      label: const Text("Nombre"),
                      errorText: _formKey.currentState?.validate() == false ? "Campo obligatorio" : null,
                    ),
                    onChanged: (value) => _formKey.currentState?.validate(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      if(value.characters.length < 5){
                        return 'El nombre debe tener al menos 5 caracteres';
                      }
                      return null;
                  },
                  ),
                ),
                const SizedBox(height: 15,),
                ElevatedButton(onPressed: (){
                  if(_formKey.currentState?.validate() == true){
                    UserService().updateUserName(nameController.text.trim());
                    Navigator.pop(context);
                    setState(() {
                      newName = nameController.text.trim();
                    });
                  }
                }, child: const Text("Actualizar"))
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.usuario,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    tooltip: "Atrás",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  title: 
                  newName != null ?
                  Text(
                    newName!.length > 30
                      ? newName!.substring(0, 30)
                      : newName!, 
                      style: const TextStyle(fontSize: 18, overflow: TextOverflow.visible),
                  )
                  : 
                  Text(
                    snapshot.data!.name.length > 30
                      ? snapshot.data!.name.substring(0, 30)
                      : snapshot.data!.name, 
                      style: const TextStyle(fontSize: 18, overflow: TextOverflow.visible),
                    ),
                  //AppBar buttons
                  actions: [
                    //Reportar perfil (solo se mostrará en perfil != auth.user)
                    isMyProfile
                        ? DropdownButton(
                          underline: const SizedBox.shrink(),
                          onChanged: (value) {
                            switch(value){
                              case '1':
                                openEditNameForm();
                                break;
                            }
                          },
                          items: const [
                            DropdownMenuItem(value: "1", child: Text("Editar Nombre")),
                          ],
                          icon: const Icon(Icons.more_vert))
                        : IconButton(
                            tooltip: "Reportar usuario",
                            onPressed: () {},
                            icon: const Icon(Icons.info)),
                  ],
                ),
                body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                  return <Widget>[
                    
                      SliverToBoxAdapter(
                        child: Card(
                        elevation: 0,
                        child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Column(children: [
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //photo, name and email
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.ce,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                          isMyProfile ? 
                                              openUpdatePhotoOptions() : 
                                              openProfilePhoto(snapshot.data!.avatarUrl!);
                                          },
                                      child: Stack(children: [
                                        ClipOval(
                                          child: Image.network(
                                            newImage ?? snapshot.data!.avatarUrl!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        isMyProfile
                                            ? const Positioned(
                                                bottom: 0,
                                                left: 0,
                                                child: Icon(
                                                  Icons.add_a_photo,
                                                  size: 20,
                                                ))
                                            : const SizedBox.shrink(),
                                      ]),
                                    ),
                  
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      newName ?? snapshot.data!.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //const SizedBox(height: 10,),
                                    Text(snapshot.data!
                                        .email), // El usuario decide si mostrar o no el email
                                  ],
                                ),
                                ]
                              ),
                              //Información extra: fecha de creación de perfil, ubicación,
                              //  UBICACIÓN
                              const SizedBox(height: 10,),
                              ExtraInfo(
                                  icon: const Icon(Icons.my_location),
                                  text: snapshot.data!.location.toString()),
                              //FECHA DE REGISTRO
                              ExtraInfo(
                                icon: const Icon(Icons.waving_hand_outlined),
                                text:
                                    "Se unió el ${DateFormat("d 'de' MMMM 'del' yyyy", 'es').format(DateFormat('dd-MM-yyyy hh:mm:ss').parse(snapshot.data!.createdAt!))}",
                              ),
                              //NUMERO DE COMUNIDADES
                  
                              Flex(direction: Axis.horizontal, children: const [
                                ExtraInfo(
                                    icon: Icon(Icons.public),
                                    text: "Comunidades 10"),
                                SizedBox(
                                  width: 10,
                                ),
                                ExtraInfo(
                                    icon: Icon(Icons.post_add),
                                    text: "Publicaciones 1000")
                              ]),
                            ]),
                            ),
                          ),
                      ),
                      /// USER DATA CARD
                      
                      // ************* Añade una publicación **********
                      
                      SliverToBoxAdapter(
                        child: Offstage(
                          offstage: !isMyProfile,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,0,0),
                            child: Row(
                              children: [
                                FloatingActionButton(
                                  onPressed: (){
                                    //Go to create post page
                                  },
                                  child: const Icon(Icons.edit_square),
                                ),
                                const Text("   Crea una nueva publicación")
                              ],
                            ),
                          ),
                        ),
                      ),
                   
                      SliverAppBar(
                        elevation: 0,
                        toolbarHeight: 0,
                        pinned: true,
                        backgroundColor: MyApp.themeNotifier.value == ThemeMode.dark ? Colors.grey[800] : Colors.white,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(58),
                          child: TabBar(
                              controller: _tabBarController,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: const [
                                ListTile(
                                  horizontalTitleGap: 0,
                                  minLeadingWidth: 20,
                                  leading: Icon(
                                    Icons.fact_check,
                                    size: 20,
                                  ),
                                  contentPadding: EdgeInsets.all(0),
                                  title: Center(
                                      child: Text(
                                    "Mis publicaciones",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )),
                                ),
                                ListTile(
                                  horizontalTitleGap: 0,
                                  minLeadingWidth: 20,
                                  leading: Icon(
                                    Icons.thumb_up,
                                    size: 20,
                                  ),
                                  title: Center(
                                      child: Text(
                                    "Me gusta",
                                    style: TextStyle(fontSize: 14),
                                  )),
                                ),
                              ]),
                          ),
                        ),
                  ];
                
                  },
                  body: TabBarView(
                          controller: _tabBarController,
                          children: [
                            Posts(authorID: snapshot.data!.id!),
                            Interactions(authorID: snapshot.data!.id!),
                          ],
                               
                        ),
                ),
              );       
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        }
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
