import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationsManager {
  static List<AppInfo> allApps = [];
  late SharedPreferences sh;

  start() async {
    await _getSharedPreferencesApplications();
  }

  _getSharedPreferencesApplications() async {
    sh = await SharedPreferences.getInstance();
    List<String>? _applications = sh.getStringList("applications");
    print("applications ${_applications}");
    if (_applications != null && _applications.length > 0) {
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

      allApps = shApplications;
    } else {
      allApps = await _getApplications();
    }
  }

  Future<List<AppInfo>> _getApplications() async {
    _saveApplicationsToSharedPreferences();

    return allApps = await InstalledApps.getInstalledApps(true, true);
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
}
