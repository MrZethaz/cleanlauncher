import 'dart:convert';

import 'package:clean_launcher/Screens/ApplicationList.dart';
import 'package:clean_launcher/Screens/HomePage.dart';
import 'package:clean_launcher/Screens/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<AppInfo> allApps = [];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences sh;
  bool loading = true;

  _getSharedPreferencesApplications() async {
    print("a");
    sh = await SharedPreferences.getInstance();
    List<String>? _applications = sh.getStringList("applications");
    print("applications ${_applications}");
    if (_applications != null && _applications.length > 0) {
      print("a");
      List<Map<String, dynamic>> applicationsMap = _applications
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
      List<AppInfo> shApplications = applicationsMap.map((e) {
        e["icon"] = base64Decode(e["icon"]);

        AppInfo appInfo = AppInfo(
          e["name"],
          e["icon"],
          e["package_name"],
          e["version_name"],
          e["version_code"],
        );
        return appInfo;
      }).toList();
      print("b");
      setState(() {
        allApps = shApplications;
        loading = false;
      });
    } else {
      _getApplications();
    }
  }

  _getApplications() async {
    print("async");
    allApps = await InstalledApps.getInstalledApps(true, true);

    setState(() {
      loading = false;
    });

    _saveApplicationsToSharedPreferences();
  }

  _saveApplicationsToSharedPreferences() {
    List<Map<String, dynamic>> applicationsMap =
        allApps.map((e) => e.toMap()).toList();
    List<String> applicationsString =
        applicationsMap.map((e) => jsonEncode(e)).toList();

    sh
        .setStringList("applications", applicationsString)
        .then((value) => print("Saved"));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getSharedPreferencesApplications();
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
