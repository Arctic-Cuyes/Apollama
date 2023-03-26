import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/filter/filter_chip.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';
import 'package:zona_hub/src/views/home/home_recent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List selected = [1, 2, 3];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(     
        //AppBar de posts en la página principal
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: HomeTab(),
          ),
        ),
         body: 
            const TabBarView (
              children:  [
               Recientes(),
               Recientes(),
              // Recientes(),
              ],
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
             // Tab(text: "Noticias",),
             ],
          ),
        ),
        //Filter Button
        Expanded( 
          flex: 1,
          child: IconButton(
            onPressed: (){
              //Show tags multiple selection menu 
              showBottomSheet(
                context: context,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  minWidth: double.infinity,
                ), 
                builder: (_){
                return Column(
                  children: [
                    const Text("Selecciona una categoría", style: TextStyle(fontSize: 18),),
                    Wrap(
                      children: [
                        FilterChipComponent(index: 1, label: Image.network(AuthService().currentUser.photoURL!, width: 50, height: 50,))
                      ],
                    )
                  ],
                );
              });            
            }, 
            icon: const Icon(Icons.filter_list_rounded,
            color: Colors.white,
          )),
        ),
      ],
    );
  }
}
