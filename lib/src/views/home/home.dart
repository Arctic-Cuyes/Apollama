import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/components/filter/filter_chip.dart';
import 'package:zona_hub/src/constants/tags_list.dart';
import 'package:zona_hub/src/models/tag_model.dart';
import 'package:zona_hub/src/providers/filters_provider.dart';
import 'package:zona_hub/src/utils/open_new_post_view.dart';
import 'package:zona_hub/src/views/home/home_popular.dart';
import 'package:zona_hub/src/views/home/home_recent.dart';

final FilterProvider changeNotifier = FilterProvider();

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
        body: Stack(children: [
          const PostView(),
          Positioned(
            bottom: 5,
            right: 5,
            child: FloatingActionButton(
              onPressed: () {
                //go to new_post page
                goToNewPostForm(context);
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ]),
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
              // Tab(text: "Noticias",),
            ],
          ),
        ),
        //Filter Button
        Expanded(
          flex: 1,
          child: IconButton(
              tooltip: "Filtar publicaciones",
              onPressed: () {
                //Show tags multiple selection menu

                showBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Categorías",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.cancel_rounded,
                                          size: 35,
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 60,
                              ),
                              Wrap(
                                  alignment: WrapAlignment.center,
                                  direction: Axis.horizontal,
                                  spacing: 4,
                                  children: [
                                    for (var filter in TagsList().tags)
                                      FilterChipComponent(
                                        label: filter['tag'],
                                        markerIconPath: filter['asset'],
                                        selectedColor: filter['selectedColor'],
                                      ),
                                  ]),
                              const SizedBox(
                                height: 50,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    //Set state with new filters
                                    // applyFilters(context, filters, filterProvider);
                                    changeNotifier.setRefresh(true);
                                    Navigator.pop(
                                        context); // Close filters selector
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.grey[600]),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  child: SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: const [
                                          Icon(Icons.check_circle_outlined),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Aplicar filtros",
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.filter_list_rounded,
              )),
        ),
      ],
    );
  }
}

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  List<Tag> filters = [];

  @override
  void initState() {
    super.initState();
    debugPrint("Se construye post View state y se aplican los filtros");
    changeNotifier.addListener(onSetFilterListener);
    //Al llamar al provider en init state se toma un tiempo en cargar los filtros de shared preferences
    Timer(const Duration(milliseconds: 10), () {
      setFilters();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    changeNotifier.removeListener(onSetFilterListener);
    super.dispose();
  }

  onSetFilterListener() {
    setFilters();
  }

  setFilters() {
    //clear filters
    setState(() {
      filters = [];
    });
    final filterProvider = context.read<FilterProvider>();
    for (var element in filterProvider.filters) {
      String id = TagsList().getTagId(element);
      Tag tag = Tag(name: element, id: id);
      filters.add(tag);
    }
    debugPrint("Filtros : ${filters.length}");
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Recientes(
          filters: filters,
        ),
        Popular(
          filters: filters,
        ),
        // Recientes(),
      ],
    );
  }
}
