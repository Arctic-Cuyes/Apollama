import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zona_hub/src/components/post/tagsComponent.dart';
import 'package:zona_hub/src/constants/images.dart';
import 'package:zona_hub/src/constants/tags_list.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/post_service.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
import 'package:zona_hub/src/utils/relative_time.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

//Small view of posts made by users
class PostComponent extends StatefulWidget {
  final Post post;
  
  const PostComponent(
      {Key? key,
      required this.post
    }
  ) : super(key: key);

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  int comments = 0;
  DateTime date = DateTime.now();
  int likes = 0;
  int dislikes = 0;
  bool alreadyLike = false;
  bool alreadyDislike = false;

  @override
  void initState() {
    super.initState();
    likes = widget.post.upVotes!.length;
    dislikes = widget.post.downVotes!.length;
    alreadyLike = PostService.ifPostIsAlreadyUpVotedByCurrentUser(widget.post);
    alreadyDislike = PostService.ifPostIsAlreadyDownVotedByCurrentUser(widget.post);
  }

  

  void addLike() async{
    setState(() {
      if (!alreadyLike) {
        likes++;
        alreadyLike = true;
      }

      if (alreadyDislike){
        dislikes--;
        alreadyDislike = false;
      }
    });
    try{
      await PostService().upVotePost(widget.post.id!);
    } catch(e){
      print(e);
      setState(() {
        likes--;
        alreadyDislike = false;
      });
    }
  }

  void addDislike() async{
    setState(() {
      if (!alreadyDislike){
        dislikes++;
        alreadyDislike = true;
      }
      if (alreadyLike){
        likes--;
        alreadyLike = false;
      }
    });
    try{
      await PostService().downVotePost(widget.post.id!);
    } catch(e){
      print(e);
      setState(() {
        dislikes--;
      });
    }
  }

  void addComment() {
    setState(() {
      comments++;
    });
  }
  
  void goToProfile(String userId){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => 
        ProfilePage(usuario: 
          UserService().getUserById(userId), 
          userID: userId
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = widget.post.authorData!;
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
                  onTap: () => goToProfile(user.id!),
                  child: ClipOval(
                      child: Image.network(
                      //Cambiará según la base de datos, por el momento una imagen de internet
                      user.avatarUrl ?? "https://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png",
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
                          onTap: () => goToProfile(user.id!),
                          child: Text(
                            user.name, 
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ),
                        Text(
                          RelativeTime.format(widget.post.createdAt!), 
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
                  widget.post.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Wrap(
                
                    children: [
                      for (var tag in widget.post.tagsData!) ...[
                        TagsComponent(tagStyle: TagsList().getTag(tag.name)),
                        // const SizedBox(width: 5)
                      ]
                    ]
                      
                  ),
                ),
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
                    (widget.post.description.length > 300) ? "${widget.post.description.substring(0, 300)}  ... ver más" : widget.post.description,
                  ),
                ),
              ],
            ),
          ),
          

          if (widget.post.imageUrl != "") ...[
            const Divider(
              color: Colors.transparent,
            ),
            Container(
              color: Colors.grey[200],
              child: AspectRatio(
                aspectRatio: 4 / 3,
                
                child: Image.network(
                  widget.post.imageUrl!,
                  alignment: Alignment.center,

                ),
              ),
            )
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (alreadyLike) ... [
                IconButton(
                  icon: const Icon(
                    Iconsax.like_15,
                    color: GlobalColors.mainColor,
                  ),
                  onPressed: addLike,
                ),

              ] else ... [
                IconButton(
                  icon: const Icon(
                    Iconsax.like_1
                  ),
                  onPressed: addLike,
                ),
              ],

              Text(likes.toString()),
              if (alreadyDislike) ... [
                IconButton(
                  icon: const Icon(
                    Iconsax.dislike5,
                    color: GlobalColors.mainColor,
                  ),
                  onPressed: addDislike,
                ),
              ] else ... [
                IconButton(
                  icon: const Icon(
                    Iconsax.dislike
                  ),
                  onPressed: addDislike,
                ),
              ],


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