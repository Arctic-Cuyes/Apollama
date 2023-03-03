import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: 
        FloatingActionButton(
          onPressed: () {
            
          },
          child: const Icon(Icons.add),
        )
      ,
    );
  }
}