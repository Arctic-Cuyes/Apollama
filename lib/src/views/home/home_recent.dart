import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';

class Recientes extends StatefulWidget {
  const Recientes({super.key});

  @override
  State<Recientes> createState() => _RecientesState();
}

class _RecientesState extends State<Recientes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot){
          return ListView.builder(
          itemCount: 10, //lista.length
          itemBuilder: (context, index) {
            // Se reemplazará por la lista de posts obtenida desde la base de datos
            return const PostComponent(
              userphoto: "https://i.pinimg.com/originals/30/8d/79/308d795c3cac0f8f16610f53df4e1005.jpg",
              username: "User Name ",
              imageUrl: "https://www.hogarmania.com/archivos/201910/mascota-perdida-XxXx80.jpg",
              postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean non massa fringilla, laoreet diam ac, egestas diam. Maecenas ullamcorper nunc eget convallis porttitor. Donec volutpat odio turpis, a interdum velit iaculis ut. Nullam commodo lacinia condimentum. Sed mauris odio, fermentum sit amet odio a, gravida condimentum ipsum. Vestibulum commodo quam ut laoreet blandit. Suspendisse ornare erat nisl, vitae faucibus ante tincidunt in. Aenean rhoncus accumsan ligula, a aliquam turpis gravida vel. Duis diam ligula, rhoncus ullamcorper arcu at, aliquam rutrum felis. Nam semper, orci sed gravida pharetra, enim nisl placerat orci, et tincidunt enim nunc a sapien. Donec eleifend diam vitae elit placerat pulvinar. Sed aliquam tortor sit amet ultrices vulputate.",
            );
          },
        );
      } 
    );
  }
}
