import 'package:flutter/material.dart';
import 'package:ui_challenge_practice/3d_drawer/3d_drawer.dart';
import 'package:ui_challenge_practice/filter_menu/filter_menu_screen.dart';
import 'package:ui_challenge_practice/kinetic_poster/kinetic_poster.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const DrawerAnimationScreen(),
    );
  }
}
