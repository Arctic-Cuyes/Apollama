import 'package:flutter/material.dart';
import 'package:zona_hub/src/styles/global.colors.dart';
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
      length: 3,
      child: Scaffold(     
        //AppBar de posts en la página principal
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
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
               Recientes(),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
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
              color: GlobalColors.blue,
            )),
          ),
        ],
      ),
    );
  }
}
