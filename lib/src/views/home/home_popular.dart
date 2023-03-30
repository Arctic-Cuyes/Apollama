import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/providers/filters_provider.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/Map/gps_service.dart';
import 'package:zona_hub/src/services/post_service.dart';

class Popular extends StatefulWidget {
  const Popular({super.key});

  @override
  State<Popular> createState() => _RecientesState();
}

class _RecientesState extends State<Popular>
    with AutomaticKeepAliveClientMixin {
  final PostService postService = PostService();
  final AuthService authService = AuthService();
  final GpsService gpsService = GpsService();

  @override
  bool get wantKeepAlive => true;

  void applyFilters(filters) {
    final filterProvider = context.watch<FilterProvider>();
    for (var element in filterProvider.filters) {
      Tag tag = Tag(name: element);
      filters.add(tag);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        onRefresh: () async {
         setState(() {});
        },
        child: FutureBuilder(
          future: gpsService.determinePosition(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // if has data return a stream builder
            if (snapshot.hasData) {
              List<Tag> filters = [];
              applyFilters(filters);
              return StreamBuilder<List<Post>>(
                  stream: postService.getPostsAround(
                      position: snapshot.data as Position,
                      tags: filters,
                  ),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Post>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("No hay publicaciones cerca", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
                            const SizedBox(height: 20),
                            const Icon(
                              Icons.hourglass_empty,
                              size: 150,
                            ),
                            IconButton(
                              iconSize: 50,
                              onPressed: () async {
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.change_circle,
                                size: 50,
                              ),
                            )
                            
                          ],
                        ),
                      );
                    }

                    return ListView(
                      children: snapshot.data!.map((Post post) {
                        return PostComponent(
                          post: post,
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