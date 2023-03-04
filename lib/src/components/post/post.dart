import 'package:flutter/material.dart';

//Small view of posts made by users
class PostComponent extends StatefulWidget {
  final String userphoto;
  final String username;
  final String imageUrl;
  final String postText;
  
  const PostComponent(
      {Key? key,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                  child: Image.network(
                  //Cambiará según la base de datos, por el momento una imagen de internet
                  widget.userphoto,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(widget.username, style: const TextStyle(fontSize: 16),),
                      const Text("Hace un momento", style: TextStyle(fontSize: 11),)
                  ],
                ),
              ) ,
            ]
          ),
          //User image
          const Divider(),
          Text(
            (widget.postText.length > 255) ? "${widget.postText.substring(0, 255)}  ... ver más" : widget.postText,
          ),
          const Divider(
            color: Colors.transparent,
          ),
          Image.network(widget.imageUrl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_alt),
                onPressed: addLike,
              ),
              Text(likes.toString()),
              IconButton(
                icon: const Icon(Icons.thumb_down),
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
