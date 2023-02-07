import 'package:flutter/material.dart';

Route pushRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        ).chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn)).animate(animation),
        child: child,
      );
    },
  );
}