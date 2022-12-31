import 'package:clean_launcher/Screens/ApplicationList.dart';
import 'package:clean_launcher/Screens/HomePage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      children: [HomePage(), ApplicationList()],
    ));
  }
}
