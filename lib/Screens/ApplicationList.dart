import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({super.key});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  List<Application> applications = [];
  List<Application> allApps = [];
  List<String> appNames = [];
  ConnectionState state = ConnectionState.active;

  bool abc = true;
  TextEditingController searchApp = TextEditingController();

  _getApplications() async {
    allApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);
    appNames = allApps.map((e) => e.appName).toList();
    applications = allApps;
    setState(() {
      state = ConnectionState.done;
    });
  }

  _sortList() {
    if (abc) {
      applications.sort(((a, b) => a.appName.compareTo(b.appName)));
    } else {
      applications.sort(((a, b) => b.appName.compareTo(a.appName)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getApplications();
    applications = allApps;
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
    List<Application> tempApps = [];
    for (String appName in appNames) {
      String app = appName.toLowerCase();
      if (app.contains(text)) {
        int index = 0;
        for (Application application in allApps) {
          if (application.appName.toLowerCase() == app) {
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
              DeviceApps.openApp(applications[index].packageName);
            },
            onLongPress: () {
              DeviceApps.openAppSettings(applications[index].packageName);
            },
            leading: Image.memory(
                (applications[index] as ApplicationWithIcon).icon,
                height: 40),
            title: Text(
              applications[index].appName,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              applications[index].packageName,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
