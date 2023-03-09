import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/services/firabase_service.dart';

class Recientes extends StatefulWidget {
  const Recientes({super.key});

  @override
  State<Recientes> createState() => _RecientesState();
}

class _RecientesState extends State<Recientes> {
  @override
  Widget build(BuildContext context) {
    //RefreshIndicator para actualizar la pantalla de posts cuando se desliza hacia abajo
    //estando en el primer post del ListView
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        setState(() {
          
        });
      } ,
      child: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
            
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return PostComponent(
                postText: snapshot.data?[index]['description'],
                imageUrl: 'https://www.hogarmania.com/archivos/201910/mascota-perdida-XxXx80.jpg',
                userphoto: "https://i.pinimg.com/originals/30/8d/79/308d795c3cac0f8f16610f53df4e1005.jpg",
                username: "nobody",
              );
            },
          );
        },
      ),
    );
  }
}
