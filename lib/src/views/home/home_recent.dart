import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/user_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Map/gps_service.dart';
import 'package:zona_hub/src/services/post_service.dart';
import 'package:zona_hub/src/utils/post_query.dart';

class Recientes extends StatefulWidget {
  const Recientes({super.key});

  @override
  State<Recientes> createState() => _RecientesState();
}

class _RecientesState extends State<Recientes> {
  final PostService postService = PostService();
  final AuthService authService = AuthService();
  final GpsService gpsService = GpsService();
  @override
  Widget build(BuildContext context) {
    // postService.upVotePost('Ds4y5VrxxJo6LkXZamxI');
    return RefreshIndicator(
        color: Colors.white,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: Future.wait(
              [gpsService.determinePosition(), authService.getCurrentUser()]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // if has data return a stream builder
            if (snapshot.hasData) {
              final Position position = snapshot.data[0] as Position;
              final UserModel currentUser = snapshot.data[1] as UserModel;
              return StreamBuilder<List<Post>>(
                  stream: postService.getPostsAround(
                      position: position,
                      currentUser: currentUser,
                      query: PostQuery.noVoted),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      children: snapshot.data!.map((Post post) {
                        return PostComponent(
                          userID: post.author!.id,
                          postText: post.description,
                          imageUrl: post.imageUrl,
                          userphoto: post.authorData!.avatarUrl!,
                          username: post.authorData!.name,
                        );
                      }).toList(),
                    );
                  });
            }
            // if has no data return a circular progress indicator
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
