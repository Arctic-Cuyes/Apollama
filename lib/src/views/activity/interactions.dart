import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/models/post_model.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/services/user_service.dart';

class Interactions extends StatefulWidget {
  
  const Interactions({super.key});

  @override
  State<Interactions> createState() => _InteractionsState();
}

class _InteractionsState extends State<Interactions> with AutomaticKeepAliveClientMixin {
  final UserService userService = UserService();
  final AuthService authService = AuthService();

  @override
  bool get wantKeepAlive => true;
  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Post>>(
      stream: userService.getUserReactedPosts(authService.currentUser.uid), 
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
            children: snapshot.data!.map((Post post) {
              return PostComponent(
                post: post,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}