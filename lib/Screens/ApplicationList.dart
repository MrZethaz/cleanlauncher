import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({super.key});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  List<AppInfo> applications = [];
  List<AppInfo> allApps = [];
  List<String> appNames = [];
  ConnectionState state = ConnectionState.active;

  bool abc = true;
  TextEditingController searchApp = TextEditingController();

  late SharedPreferences sh;

  _getSharedPreferencesApplications() async {
    sh = await SharedPreferences.getInstance();
    List<String>? _applications = sh.getStringList("applications");
    print(applications.toString());
    if (_applications != null && _applications.length > 0) {
      print("a");
      List<Map<String, dynamic>> applicationsMap = _applications
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();
      List<AppInfo> shApplications = applicationsMap.map((e) {
        e["icon"] =
            (Uint8List.fromList((e["icon"] as String).codeUnits) as Uint8List)
                .toString();

        AppInfo appInfo = AppInfo(
          e["name"],
          Uint8List.fromList((e["icon"] as String).codeUnits),
          e["package_name"],
          e["version_name"],
          e["version_code"],
        );
        return appInfo;
      }).toList();
      setState(() {
        allApps = shApplications;
        state = ConnectionState.done;
      });
    }
    _getApplications();
  }

  _getApplications() async {
    print("async");
    allApps = await InstalledApps.getInstalledApps(true, true);
    appNames = allApps.map((e) => e.name!).toList();
    applications = allApps;

    for (AppInfo application in allApps) {
      precacheImage(MemoryImage(application.icon!), context);
    }
    setState(() {
      state = ConnectionState.done;
    });

    _saveApplicationsToSharedPreferences();
  }

  _sortList() {
    if (abc) {
      applications.sort(((a, b) => a.name!.compareTo(b.name!)));
    } else {
      applications.sort(((a, b) => b.name!.compareTo(a.name!)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSharedPreferencesApplications();

    applications = allApps;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //applications.sort(((a, b) => a.appName.compareTo(b.appName)));
    _sortList();

    return Container(
      color: Colors.black,
      child: state == ConnectionState.done
          ? _getApplicationPageWhenLoadedApps()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _onChangedSearchAppText(String change) {
    String text = searchApp.text.toLowerCase();

    if (text.length == 0) {
      setState(() {
        applications = allApps;
      });
    }
    List<AppInfo> tempApps = [];
    for (String appName in appNames) {
      String app = appName.toLowerCase();
      if (app.contains(text)) {
        int index = 0;
        for (AppInfo application in allApps) {
          if (application.name!.toLowerCase() == app) {
            break;
          }
          index++;
        }
        tempApps.add(allApps[index]);
        print(app);
      }
    }
    print(tempApps.length);
    setState(() {
      applications = tempApps;
    });
  }

  _getApplicationPageWhenLoadedApps() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  child: TextField(
                controller: searchApp,
                onChanged: _onChangedSearchAppText,
                decoration: InputDecoration(
                  labelText: "Search app",
                ),
              )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      abc = !abc;
                      _sortList();
                    });
                  },
                  icon: Icon(
                    Icons.sort_by_alpha,
                  ))
            ]),
            SizedBox(
              height: 8,
            ),
            _getApplicationList()
          ],
        ),
      ),
    );
  }

  _getApplicationList() {
    return Expanded(
      child: ListView.separated(
        primary: false,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.white,
            thickness: 0.15,
          );
        },
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              InstalledApps.startApp(applications[index].packageName!);
            },
            onLongPress: () {
              InstalledApps.openSettings(applications[index].packageName!);
            },
            leading: Image.memory(applications[index].icon!, height: 40),
            title: Text(
              applications[index].name!,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              applications[index].packageName!,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  _saveApplicationsToSharedPreferences() {
    List<Map<String, dynamic>> applicationsMap =
        applications.map((e) => e.toMap()).toList();
    List<String> applicationsString =
        applicationsMap.map((e) => jsonEncode(e)).toList();

    sh
        .setStringList("applications", applicationsString)
        .then((value) => print("Saved"));
  }
  /*

  Application appfromMap(Map<String, dynamic> map) {
    return Application(
        appName: map["app_name"],
        apkFilePath: map["apk_file_path"],
        versionName: map["version_name"],
        versionCode: map["version_code"],
        dataDir: map["data_dir"],
        systemApp: map["system_app"],
        installTimeMillis: map["install_time"],
        updateTimeMillis: map["update_time"],
        enabled: map["is_enabled"],
        category: _parseCategory(map["category"]));
  }

  ApplicationCategory _parseCategory(Object? category) {
    if (category is num && category < 0) {
      return ApplicationCategory.undefined;
    } else if (category == 0) {
      return ApplicationCategory.game;
    } else if (category == 1) {
      return ApplicationCategory.audio;
    } else if (category == 2) {
      return ApplicationCategory.video;
    } else if (category == 3) {
      return ApplicationCategory.image;
    } else if (category == 4) {
      return ApplicationCategory.social;
    } else if (category == 5) {
      return ApplicationCategory.news;
    } else if (category == 6) {
      return ApplicationCategory.maps;
    } else if (category == 7) {
      return ApplicationCategory.productivity;
    } else {
      return ApplicationCategory.undefined;
    }
  }

  Map<String, dynamic> appToMap(Application a) {
    return {
      "app_name": a.appName,
      "apk_file_path": a.apkFilePath,
      "version_name": a.versionName,
      "version_code": a.versionCode,
      "data_dir": a.dataDir,
      "system_app": a.systemApp,
      "install_time": a.installTimeMillis,
      "update_time": a.updateTimeMillis,
      "is_enabled": a.enabled,
      "category": categoryToInt(a.category)
    };
  }

  int categoryToInt(ApplicationCategory category) {
    if (category == ApplicationCategory.undefined) {
      return -1;
    } else if (category == ApplicationCategory.game) {
      return 0;
    } else if (category == ApplicationCategory.audio) {
      return 1;
    } else if (category == ApplicationCategory.video) {
      return 2;
    } else if (category == ApplicationCategory.image) {
      return 3;
    } else if (category == ApplicationCategory.social) {
      return 4;
    } else if (category == ApplicationCategory.news) {
      return 5;
    } else if (category == ApplicationCategory.maps) {
      return 6;
    } else if (category == ApplicationCategory.productivity) {
      return 7;
    } else {
      return -1;
    }
  }
   */
}
