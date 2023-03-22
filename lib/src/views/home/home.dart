import 'package:flutter/material.dart';
import 'package:zona_hub/src/views/home/home_recent.dart';
import 'package:zona_hub/src/views/post/post_new.dart';

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
          // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: HomeTab(),
          ),
        ),
        body: const TabBarView(
          children: [
            Recientes(),
            Recientes(),
            Recientes(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _goToNewPostForm(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _goToNewPostForm(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => NewPostForm(),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 2);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(begin: begin, end: end);

          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        }));
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 5,
          child: TabBar(
            tabs: [
              Tab(
                text: "Recientes",
              ),
              Tab(
                text: "Popular",
              ),
              Tab(
                text: "Noticias",
              ),
            ],
          ),
        ),
        //Filter Button
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                //Show tags multiple selection menu
              },
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
