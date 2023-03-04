import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(     
        //AppBar de posts en la página principal
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: HomeTab(),
          ),
        ),
         body: 
            RefreshIndicator(
              onRefresh: () async {
                //simulate a database query
                await Future.delayed(const Duration(seconds: 2)); 
                setState(() {
                  
                });              
              },
              child: const TabBarView (
                children:  [
                 Recientes(),
                 Text("data"),
                 Text("data"),
                ],
              ),
            ),
        floatingActionButton: 
          FloatingActionButton(
            onPressed: () {
              //go to new_post page
            },
            child: const Icon(Icons.add),
          )
        ,
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
         const Expanded(
          flex: 5,
          child: TabBar(
             tabs: [
              Tab(text: "Recientes",),
              Tab(text: "Popular",),
              Tab(text: "Noticias",),
             ],
          ),
        ),
        //Filter Button
        Expanded( 
          flex: 1,
          child: IconButton(
            onPressed: (){
              //Show tags multiple selection menu             
            }, 
            icon: const Icon(Icons.filter_list_rounded,
            color: Colors.amber,
          )),
        ),
      ],
    );
  }
}

// Lista de publicaciones recientes

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

