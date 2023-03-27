import 'package:flutter/material.dart';
import 'package:zona_hub/src/constants/images.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/utils/relative_time.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

//Small view of posts made by users
class PostComponent extends StatefulWidget {
  final String userID;
  final String userphoto;
  final String username;
  final String imageUrl;
  final String postText;
  final String title;
  
  const PostComponent(
      {Key? key,
      required this.userID,
      required this.userphoto,
      required this.username,
      required this.imageUrl,
      required this.postText,
      required this.title}
  ) : super(key: key);

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  int likes = 0;
  int dislikes = 0;
  int comments = 0;
  DateTime date = DateTime(2023, 3, 23);

  void addLike() {
    setState(() {
      likes++;
    });
  }

  void addDislike() {
    setState(() {
      dislikes++;
    });
  }

  void addComment() {
    setState(() {
      comments++;
    });
  }
  
  void goToProfile(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => 
        ProfilePage(usuario: 
          UserService().getUserById(widget.userID), 
          userID: widget.userID
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => goToProfile(),
                  child: ClipOval(
                      child: Image.network(
                      //Cambiará según la base de datos, por el momento una imagen de internet
                      widget.userphoto,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        //Tap the name to go to profile
                        GestureDetector(
                          onTap: () => goToProfile(),
                          child: Text(
                            widget.username, 
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ),
                        Text(
                          RelativeTime.format(date), 
                          style: TextStyle(fontSize: 11),
                        )
                    ],
                  ),
                ),
                const Spacer(),
                VerEnMapa()
              ]
            ),
          ),
          //User image
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: GlobalColors.mainColor,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    (widget.postText.length > 300) ? "${widget.postText.substring(0, 300)}  ... ver más" : widget.postText,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.transparent,
          ),
          Container(
            color: Colors.grey[200],
            child: AspectRatio(
              aspectRatio: 4 / 3,
              
              child: Image.network(
                widget.imageUrl,
                alignment: Alignment.center,
                // max heigth: 300,
                // fit: BoxFit.cover,
                // height: double.infinity,
                // width: double.infinity,
                
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_off_alt_outlined),
                onPressed: addLike,
              ),
              Text(likes.toString()),
              IconButton(
                icon: const Icon(Icons.thumb_down_alt_outlined),
                onPressed: addDislike,
              ),
              Text(dislikes.toString()),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: addComment,
              ),
              Text(comments.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class VerEnMapa extends StatefulWidget {
  // TODO: no se que datos se necesiten para mostrar el mapa.
  // Talvez el location de la publicacion

  const VerEnMapa({super.key});

  @override
  State<VerEnMapa> createState() => _VerEnMapaState();
}

class _VerEnMapaState extends State<VerEnMapa> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () {},
      child: Row(
        children: [
          Image.asset(GlobalConstansImages.googleMapMarker, width: 20, height: 20),
          const Text(
            "Ver en mapa",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],),
    );
  }
}