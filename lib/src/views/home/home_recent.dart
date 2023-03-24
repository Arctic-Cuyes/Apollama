import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/post_service.dart';

class Recientes extends StatefulWidget {
  const Recientes({super.key});

  @override
  State<Recientes> createState() => _RecientesState();
}

class _RecientesState extends State<Recientes> {
  final PostService postService = PostService();
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: Colors.white,
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<List<Post>>(
          stream: postService.getPosts(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.map((Post post) {
                return PostComponent(
                  userID: post.authorData!.id!,
                  postText: post.description,
                  imageUrl: post.imageUrl,
                  userphoto: post.authorData!.avatarUrl!,
                  username: post.authorData!.name,
                );
              }).toList(),
            );
          },
        ));
  }
}
