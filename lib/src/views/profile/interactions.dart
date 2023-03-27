import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/user_service.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

class Interactions extends StatefulWidget {
  final String authorID; 
  const Interactions({super.key, required this.authorID});

  @override
  State<Interactions> createState() => _InteractionsState();
}

class _InteractionsState extends State<Interactions> with AutomaticKeepAliveClientMixin {
  final UserService userService = UserService();

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Post>>(
      stream: userService.getUserReactedPosts(widget.authorID), 
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
    
        if(snapshot.data!.isEmpty){
          return  Column(
            children: const [
              SizedBox(height: 181,),
              Icon(Icons.comment, size: 120,),
              Text("Aún no tienes interacciones", style: TextStyle(fontSize: 20),)                
            ],
          ) ;
        }
    
        return RefreshIndicator(
          onRefresh: () async => setState((){}),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.map((Post post) {
              return PostComponent(
                userID: post.authorData!.id!,
                postText: post.description,
                imageUrl: post.imageUrl,
                userphoto: newImage ?? post.authorData!.avatarUrl!,
                username: newName ?? post.authorData!.name,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}