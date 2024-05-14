import 'package:flutter/material.dart';

Route routeSlide({required Widget page, Curve curved = Curves.easeInOut}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = 0.0;
      final end = 1.0;
      final curvedAnimation = Tween(begin: begin, end: end).animate(animation);
      return FadeTransition(
        opacity: curvedAnimation,
        child: child,
      );
    },
  );
}

Route routeFade({required Widget page, Curve curved = Curves.easeInOut}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 20),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = 0.0;
      final end = 1.0;
      final curvedAnimation = Tween(begin: begin, end: end).animate(animation);

      return FadeTransition(
        opacity: curvedAnimation,
        child: child,
      );
    },
  );
}
