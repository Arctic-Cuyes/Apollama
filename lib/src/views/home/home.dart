import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/filter/filter_chip.dart';
import 'package:zona_hub/src/constants/custom_filter_images.dart';
import 'package:zona_hub/src/views/home/home_recent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(     
        //AppBar de posts en la página principal
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          bottom: const PreferredSize(

            preferredSize: Size.fromHeight(48),
            child: HomeTab(),
          ),
        ),
         body: 
         Stack(
           children: [
             const TabBarView (
              children:  [
               Recientes(),
               Recientes(),
              // Recientes(),
              ],
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                  onPressed: () {
                    //go to new_post page
                  },
                  child: const Icon(Icons.add, color: Colors.white,),
                ),

            )
            
           ]
         ),
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
            tooltip: "Filtar publicaciones",
            onPressed: (){
              //Show tags multiple selection menu 
              
              // showBottomSheet(
              //   backgroundColor: Colors.transparent,
              //   context: context,
              //   constraints: const BoxConstraints(
              //     maxHeight: 120
              //   ), 
              //   builder: (_){
              //   final List<Map<String, dynamic>> tags = [
              //     {'tag': 'Animales', 'asset': CustomFilterIcon.pet, 'selectedColor': Colors.brown}, 
              //     {'tag': 'Ayuda', 'asset': CustomFilterIcon.ayuda, 'selectedColor': Colors.pink},
              //     {'tag': 'Avisos', 'asset': CustomFilterIcon.aviso, 'selectedColor': Colors.red}, 
              //     {'tag': 'Eventos', 'asset': CustomFilterIcon.evento, 'selectedColor': Colors.orange}, 
              //     {'tag': 'Salud', 'asset': CustomFilterIcon.salud, 'selectedColor': Colors.blue},
              //   ];
              //   return BackdropFilter(
              //     filter: ImageFilter.blur(
              //       sigmaX: 20,
              //       sigmaY: 20
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         SizedBox(
              //           height: 120,
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: tags.map(
              //               (filters){
              //                 return FilterChipComponent(
              //                   label: filters['tag'], 
              //                   markerIconPath: filters['asset'],
              //                   selectedColor: filters['selectedColor'],
              //                 );
              //               }
              //             ).toList(),
              //           ),
              //         )
              //       ],
              //     ),
              //   );
              // }
              // );            
            }, 
            icon: const Icon(Icons.filter_list_rounded,)
          ),
        ),
      ],
    );
  }
}
