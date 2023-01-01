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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  ApplicationsManager applicationsManager = ApplicationsManager();

  _getApplications() async {
    await applicationsManager.start();
    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: loading
            ? SplashScreen()
            : PageView(
                children: [HomePage(), ApplicationList()],
              ));
  }
}
