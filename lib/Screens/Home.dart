import 'dart:convert';

import 'package:clean_launcher/Base/ApplicationsManager.dart';
import 'package:clean_launcher/Screens/ApplicationList.dart';
import 'package:clean_launcher/Screens/HomePage.dart';
import 'package:clean_launcher/Screens/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watcher/watcher.dart';

ApplicationsManager applicationsManager = ApplicationsManager();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  late SharedPreferences sh;
  PageController pageController = PageController(initialPage: 0);
  int startIndex = 0;

  _getApplications() async {
    sh = await SharedPreferences.getInstance();
    await applicationsManager.start();
    int? start = sh.getInt("startIndex");
    if (start != null) {
      print(start);
      setState(() {
        startIndex = start;
      });
      //sh.setInt("startIndex", 0);
    }
    setState(() {
      loading = false;
    });
    _animateToPage();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getApplications();
  }

  _animateToPage() {
    if (loading == false) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => pageController.jumpToPage(startIndex));
      sh.setInt("startIndex", 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    applicationsManager.getApplications();
    _animateToPage();

    return Scaffold(
        backgroundColor: Colors.black,
        body: loading
            ? SplashScreen()
            : PageView(
                controller: pageController,
                children: [HomePage(), ApplicationList()],
              ));
  }
}
