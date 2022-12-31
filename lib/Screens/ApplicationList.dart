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

  _getApplications() async {
    applications = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);

    setState(() {
      state = ConnectionState.done;
    });
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
    return Container(
      color: Colors.black,
      child: Column(children: [
        Expanded(
            child: state == ConnectionState.done
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          DeviceApps.openApp(applications[index].packageName);
                        },
                        onLongPress: () {
                          DeviceApps.openAppSettings(
                              applications[index].packageName);
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
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ))
      ]),
    );
  }
}
