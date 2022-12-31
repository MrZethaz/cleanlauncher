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
      children: [
        Container(
          color: Colors.black,
          child: Center(
            child: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          child: Center(
            child: Text(
              "Application",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ));
  }
}
