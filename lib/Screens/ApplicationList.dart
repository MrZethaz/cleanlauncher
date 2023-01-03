import 'dart:async';
import 'dart:io';

import 'package:clean_launcher/Base/ApplicationsManager.dart';
import 'package:clean_launcher/Screens/Home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:watcher/watcher.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({super.key});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  List<AppInfo> applications = [];
  List<String> appNames = [];
  ConnectionState state = ConnectionState.done;

  bool abc = true;
  TextEditingController searchApp = TextEditingController();

  _getApps() {
    setState(() {
      appNames = ApplicationsManager.allApps.map((e) => e.name!).toList();
      applications = ApplicationsManager.allApps;
    });
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
    _getApps();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _checkAppList();
  }

  @override
  Widget build(BuildContext context) {
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
        applications = ApplicationsManager.allApps;
      });
    }
    List<AppInfo> tempApps = [];
    for (String appName in appNames) {
      String app = appName.toLowerCase();
      if (app.contains(text)) {
        int index = 0;
        for (AppInfo application in ApplicationsManager.allApps) {
          if (application.name!.toLowerCase() == app) {
            break;
          }
          index++;
        }
        tempApps.add(ApplicationsManager.allApps[index]);
      }
    }
    setState(() {
      applications = tempApps;
    });
  }

  _checkAppList() {
    Timer.periodic(
      Duration(seconds: 5),
      (timer) async {
        List<AppInfo> appinfo = await InstalledApps.getInstalledApps();
        List<String?> appPackageNames =
            appinfo.map((e) => e.packageName).toList();
        List<String?> allAppsPackageNames =
            ApplicationsManager.allApps.map((e) => e.packageName).toList();

        bool appListChanged = false;
        int i = 0;

        if (appinfo.length != ApplicationsManager.allApps.length) {
          appListChanged = true;
        }
        if (!appListChanged) {
          for (AppInfo app in appinfo) {
            bool tempAppChange = true;
            for (AppInfo app2 in ApplicationsManager.allApps) {
              if (app2.packageName == app.packageName) {
                tempAppChange = false;
              }
            }
            if (tempAppChange) {
              i++;
            }
          }
          appListChanged = i > 0;
        }

        print("here2");

        print(appListChanged);

        if (appListChanged) {
          bool addedApp = appPackageNames.length > allAppsPackageNames.length;

          List<String> temporaryPackages = [];
          for (String? package
              in addedApp ? appPackageNames : allAppsPackageNames) {
            if (addedApp) {
              if (!allAppsPackageNames.contains(package))
                temporaryPackages.add(package!);
            } else {
              if (!appPackageNames.contains(package))
                temporaryPackages.add(package!);
            }
          }

          if (addedApp) {
            List<AppInfo> temporaryApps = [];

            for (String package in temporaryPackages) {
              temporaryApps.add(await InstalledApps.getAppInfo(package));
            }

            ApplicationsManager.allApps.addAll(temporaryApps);

            if (temporaryApps.isNotEmpty) {
              applicationsManager.saveApplicationsToSharedPreferences();
              Restart.restartApp();
            }
          } else {
            for (String package in temporaryPackages) {
              int index = 0;
              bool found = false;
              for (AppInfo app in ApplicationsManager.allApps) {
                if (app.packageName == package) {
                  index++;
                  found = true;
                }
              }
              if (found) ApplicationsManager.allApps.removeAt(index);
            }
            applicationsManager.saveApplicationsToSharedPreferences();
            Restart.restartApp();
          }
        }

        // applications = await applicationsManager.getApplications();
        // setState(() {
        //   state = ConnectionState.active;
        //   sleep(Duration(milliseconds: 200));
        //   state = ConnectionState.done;
        //   applications = ApplicationsManager.allApps;
        //   _onChangedSearchAppText(searchApp.text);
        //   _sortList();
        // });
      },
    );
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
                      searchApp.clear();
                      _onChangedSearchAppText("");
                    });
                  },
                  icon: Icon(
                    Icons.clear,
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
                  )),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      state = ConnectionState.active;
                    });
                    applications = await applicationsManager.getApplications();
                    setState(() {
                      _onChangedSearchAppText(searchApp.text);
                      _sortList();
                      state = ConnectionState.done;
                    });
                  },
                  icon: Icon(
                    Icons.replay_outlined,
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
}
