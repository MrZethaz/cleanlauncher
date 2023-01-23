import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationsManager {
  static List<AppInfo> allApps = [];
  late SharedPreferences sh;

  start() async {
    await _getSharedPreferencesApplications();
  }

  _getSharedPreferencesApplications() async {
    //sh = await SharedPreferences.getInstance();

    Directory path = await getApplicationSupportDirectory();

    File? _applications =
        await File.fromUri(Uri.file("${path.path}/applications.xml"));

    if (_applications.existsSync() &&
        _applications.readAsStringSync().isNotEmpty) {
      List<dynamic> applicationsString =
          jsonDecode(_applications.readAsStringSync());

      List<dynamic> applicationsMap =
          applicationsString.map((e) => jsonDecode(e)).toList();

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
      print("daub");

      getApplications();
    }
  }

  Future<List<AppInfo>> getApplications() async {
    allApps = await InstalledApps.getInstalledApps(true, true);
    saveApplicationsToSharedPreferences();
    return allApps;
  }

  Future<void> saveApplicationsToSharedPreferences() async {
    Directory path = await getApplicationSupportDirectory();

    File? _applications =
        File.fromUri(Uri.file("${path.path}/applications.xml"));

    if (!_applications.existsSync()) {
      await _applications.create(recursive: true);
    }

    List<Map<String, dynamic>> applicationsMap =
        allApps.map((e) => appToMap(e)).toList() as List<Map<String, dynamic>>;

    List<String> jsonListString =
        applicationsMap.map((e) => jsonEncode(e)).toList();
    String applicationsString = jsonEncode(jsonListString);

    _applications.writeAsString(applicationsString);
  }

  Map<String,dynamic> appToMap(AppInfo app){
    return {
      "name": app.name,
      "icon": base64.encode(app.icon!),
      "packageName": app.packageName,
      "versionName": app.versionName,
      "versionCode": app.versionCode,
  };


    /*
    String? name;
  Uint8List? icon;
  String? packageName;
  String? versionName;
  int? versionCode;
     */
  }
}
