import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Map/gps_service.dart';
import 'package:zona_hub/src/services/post_service.dart';

class Recientes extends StatefulWidget {
  const Recientes({super.key});

  @override
  State<Recientes> createState() => _RecientesState();
}

class _RecientesState extends State<Recientes> with AutomaticKeepAliveClientMixin {
  final PostService postService = PostService();
  final AuthService authService = AuthService();
  final GpsService gpsService = GpsService();
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
        future: gpsService.determinePosition(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if has data return a stream builder
          if (snapshot.hasData) {
            return StreamBuilder<List<Post>>(
              stream: postService.getPostsAround(
                position: snapshot.data as Position
              ),
                  
              builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay eventos cercanos :c'),
                  );
                }

                return ListView(
                  children: snapshot.data!.map((Post post) {
                    return PostComponent(
                      userID: post.author!.id,
                      postText: post.description,
                      imageUrl: post.imageUrl,
                      userphoto: post.authorData!.avatarUrl!,
                      username: post.authorData!.name,
                      title: post.title,
                    );
                  }).toList(),
                );
              }
            );
          }
          // if has no data return a circular progress indicator
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
