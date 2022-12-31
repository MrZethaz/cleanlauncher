import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({super.key});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  List<Application> applications = [];
  ConnectionState state = ConnectionState.active;

  bool abc = true;

  _getApplications() async {
    applications = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);

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

  _getApplicationPageWhenLoadedApps() {
    return SafeArea(
      child: Column(
        children: [
          Row(children: [
            Expanded(child: TextField()),
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
          _getApplicationList()
        ],
      ),
    );
  }

  _getApplicationList() {
    return Expanded(
      child: ListView.builder(
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
