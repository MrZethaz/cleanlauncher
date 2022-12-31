import 'package:clean_launcher/Screens/ApplicationList.dart';
import 'package:device_apps/device_apps.dart';
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
      children: [_getHomeScreen(), ApplicationList()],
    ));
  }

  _getHomeScreen() => Container(
        color: Colors.black,
        child: Center(
          child: Text(
            "19:30 hours",
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
      );
}
