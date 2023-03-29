import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zona_hub/src/app.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Storage/firebase_storage.dart';
import 'package:zona_hub/src/services/post_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/utils/open_new_post_view.dart';
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

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final AuthService authService = AuthService();
  final Storage storage = Storage();
  late TabController _tabBarController;
  bool isMyProfile = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('es');
    Timer(const Duration(milliseconds: 10), () async {
      await checkIsMyProfile();
    });
    _tabBarController = TabController(length: 1, vsync: this);
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

  openProfilePhoto(String url) {
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
        });
  }

  openUpdatePhotoOptions() {
    showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(
          maxHeight: 120,
        ),
        builder: (_) {
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Tomar Foto"),
                onTap: () =>
                    storage.getImageURL(ImageSource.camera).then((value) {
                  if (value != "0") {
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
                onTap: () =>
                    storage.getImageURL(ImageSource.gallery).then((value) {
                  if (value != "0") {
                    setState(() {
                      newImage = value;
                    });
                    storage.updateProfilePhoto(value);
                  }
                }),
              ),
            ],
          );
        });
  }

  openEditNameForm() {
    TextEditingController nameController = TextEditingController(
        text: newName ?? authService.currentUser.displayName);

    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nuevo nombre de usuario",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.cancel_rounded,
                          size: 40,
                        )),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      label: const Text("Nombre"),
                      errorText: _formKey.currentState?.validate() == false
                          ? "Campo obligatorio"
                          : null,
                    ),
                    onChanged: (value) => _formKey.currentState?.validate(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      if (value.characters.length < 5) {
                        return 'El nombre debe tener al menos 5 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 65,
                ),
                Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Aceptar editar
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            UserService()
                                .updateUserName(nameController.text.trim());
                            Navigator.pop(context);
                            setState(() {
                              newName = nameController.text.trim();
                            });
                          }
                        },
                        child: const Text("Actualizar"),
                      ),
                    ])
              ],
            ),
          );
        });
  }

  final ScrollController nestedScrollController = ScrollController();
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
                title: newName != null
                    ? Text(
                        newName!.length > 30
                            ? newName!.substring(0, 30)
                            : newName!,
                        style: const TextStyle(
                            fontSize: 18, overflow: TextOverflow.visible),
                      )
                    : Text(
                        snapshot.data!.name.length > 30
                            ? snapshot.data!.name.substring(0, 30)
                            : snapshot.data!.name,
                        style: const TextStyle(
                            fontSize: 18, overflow: TextOverflow.visible),
                      ),
                //AppBar buttons
                actions: [
                  //Reportar perfil (solo se mostrará en perfil != auth.user)
                  isMyProfile
                      ? PopupMenuButton(onSelected: (value) {
                          //If value == 0 edit profile privacity
                        }, itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 0,
                              child: Text("Editar Privacidad"),
                            )
                          ];
                        })
                      : IconButton(
                          tooltip: "Reportar usuario",
                          onPressed: () {},
                          icon: const Icon(Icons.info)),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async => setState(() {}),
                child: NestedScrollView(
                  controller: nestedScrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    // These are the slivers that show up in the "outer" scroll view.
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Card(
                          elevation: 0,
                          child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                          child: Column(children: [
                            Stack(
                              children: [
                                Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //photo, name and email
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              isMyProfile
                                                  ? openUpdatePhotoOptions()
                                                  : openProfilePhoto(snapshot
                                                      .data!.avatarUrl!);
                                            },
                                            child: Stack(children: [
                                              ClipOval(
                                                child: Image.network(
                                                  newImage ??
                                                      snapshot.data!.avatarUrl!,
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
                                    ]),
                                isMyProfile
                                    ? Positioned(
                                        right: 3,
                                        top: -6,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.all(1)),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey[10]),
                                          ),
                                          onPressed: () => openEditNameForm(),
                                          child: Row(children: [
                                            Icon(
                                              Icons.edit,
                                              color:
                                                  MyApp.themeNotifier.value ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ]),
                                        ))
                                    : const SizedBox.shrink(),
                              ]),
                              //Información extra: fecha de creación de perfil, ubicación,
                              //  UBICACIÓN
                              const SizedBox(
                                height: 10,
                              ),
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
                                //NUMERO DE COMUNIDADES (Segunda ronda)
                    
                                // Flex(direction: Axis.horizontal, children: [
                                //   ExtraInfo(
                                //       icon: Icon(Icons.public),
                                //       text: "Comunidades 0"),
                                //   SizedBox(
                                //     width: 10,
                                //   ),
                                //   ExtraInfo(
                                //       icon: Icon(Icons.post_add),
                                //       text: "Publicaciones "),
                                // ]),
                              ]),
                            ]),
                          ),
                        ),
                      ),

                      /// USER DATA CARD

                      // ************* Añade una publicación **********

                      SliverToBoxAdapter(
                        child: isMyProfile
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Row(
                                  children: [
                                    FloatingActionButton(
                                      onPressed: () {
                                        goToNewPostForm(context);
                                      },
                                      child: const Icon(Icons.edit_square),
                                    ),
                                    const Text("   Nueva publicación", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      SliverAppBar(
                        elevation: 5,
                        toolbarHeight: 0,
                        pinned: true,
                        backgroundColor:
                            MyApp.themeNotifier.value == ThemeMode.dark
                                ? Colors.grey[800]
                                : Colors.white,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(64),
                          child: ListTile(
                            onTap: () {
                              //Scroll to the top
                              nestedScrollController.animateTo(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            horizontalTitleGap: 0,
                            minLeadingWidth: 20,
                            leading: const Icon(
                              Icons.fact_check,
                              size: 30,
                            ),
                            contentPadding: const EdgeInsets.only(left: 8),
                            title: const Text(
                              "  Publicaciones",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Posts(authorID: snapshot.data!.id!),
                ),
              ),
            );
          } else {
            return Container(
                color: MyApp.themeNotifier.value == ThemeMode.light
                    ? Colors.white
                    : Colors.grey[800],
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
        });
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