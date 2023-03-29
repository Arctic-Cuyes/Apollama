import 'package:flutter/material.dart';
import 'package:zona_hub/src/views/post/post_new.dart';

void goToNewPostForm(BuildContext context) {
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
