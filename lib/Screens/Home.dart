import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      children: [_getHomeScreen(), _getApplicationsScreen()],
    ));
  }

  _getHomeScreen() => Container(
        color: Colors.black,
        child: Center(
          child: Text(
            "19:30 hours",
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
      );
  _getApplicationsScreen() => Container(
        color: Colors.black,
        child: Column(children: [
          Expanded(
              child: FutureBuilder(
            future: DeviceApps.getInstalledApplications(
                includeAppIcons: true,
                includeSystemApps: true,
                onlyAppsWithLaunchIntent: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Application> applications = snapshot.data!;
                return ListView.builder(
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "Application ${index.toString()}",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ]),
      );
}
