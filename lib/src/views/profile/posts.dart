import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/post_service.dart';
import 'package:zona_hub/src/views/profile/profile.dart';

class Posts extends StatefulWidget {
  final String authorID; 
  const Posts({super.key, required this.authorID,});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> with AutomaticKeepAliveClientMixin {
  final PostService postService = PostService();

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Post>>(
      stream: postService.getPostsByAuthorId(widget.authorID), 
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
    
        if(snapshot.data!.isEmpty){
          return Column(
            children: const [
              SizedBox(height: 150,),
              Icon(Icons.edit_note_rounded, size: 150,),
              Text("Tus publicaciones aparecerán aquí", style: TextStyle(fontSize: 20),)                
            ],
          );
        }
    
        return RefreshIndicator(
          onRefresh: () async => setState((){}),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.map((Post post) {
              return PostComponent(
                title: post.title,
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