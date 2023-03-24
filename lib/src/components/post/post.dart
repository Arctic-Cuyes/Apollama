import 'package:flutter/material.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

//Small view of posts made by users
class PostComponent extends StatefulWidget {
  final String userID;
  final String userphoto;
  final String username;
  final String imageUrl;
  final String postText;
  
  const PostComponent(
      {Key? key,
      required this.userID,
      required this.userphoto,
      required this.username,
      required this.imageUrl,
      required this.postText}
  ) : super(key: key);

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  int likes = 0;
  int dislikes = 0;
  int comments = 0;

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(usuario: UserService().getUserById(widget.userID), userID: widget.userID)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      //Tap the name to go to profile
                      GestureDetector(
                        onTap: () => goToProfile(),
                        child: Text(widget.username, style: const TextStyle(fontSize: 16),)
                      ),
                      const Text("Hace un momento", style: TextStyle(fontSize: 11),)
                  ],
                ),
              ) ,
            ]
          ),
          //User image
          const Divider(),
          Text(
            (widget.postText.length > 300) ? "${widget.postText.substring(0, 300)}  ... ver más" : widget.postText,
          ),
          const Divider(
            color: Colors.transparent,
          ),
          Image.network(widget.imageUrl),
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
