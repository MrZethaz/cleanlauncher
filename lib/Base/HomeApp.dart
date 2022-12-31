import 'package:clean_launcher/Screens/Home.dart';
import 'package:flutter/material.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark()
              .copyWith(primary: Colors.white, secondary: Colors.white)),
    );
  }
}
