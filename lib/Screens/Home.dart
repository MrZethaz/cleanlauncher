import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:clean_launcher/Screens/ApplicationList.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime time = DateTime.now();
  var battery = Battery();

  int percentage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBatteryPerentage();
  }

  @override
  Widget build(BuildContext context) {
    updateTime();
    return Scaffold(
        body: PageView(
      children: [_getHomeScreen(), ApplicationList()],
    ));
  }

  void getBatteryPerentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  updateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        time = DateTime.now();
      });
    });
  }

  _getHomeScreen() {
    NumberFormat formatter = new NumberFormat("00");

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            children: [
              _getBatteryIcon(),
              Text(
                "${percentage}%",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              )
            ],
          ),
          Expanded(child: Container()),
          Text(
            "${DateTime.now().hour}:${formatter.format(DateTime.now().minute)}:${formatter.format(DateTime.now().second)}",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          Text(
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 64,
          ),
          Expanded(child: Container()),
        ]),
      ),
    );
  }

  _getBatteryIcon() {
    double batteryPercentagePart = 100 / 7;
    if (percentage >= batteryPercentagePart * 7) {
      return Icon(Icons.battery_full);
    } else if (percentage > batteryPercentagePart * 6) {
      return Icon(Icons.battery_6_bar);
    } else if (percentage > batteryPercentagePart * 5) {
      return Icon(Icons.battery_5_bar);
    } else if (percentage > batteryPercentagePart * 4) {
      return Icon(Icons.battery_4_bar);
    } else if (percentage > batteryPercentagePart * 3) {
      return Icon(Icons.battery_3_bar);
    } else if (percentage > batteryPercentagePart * 2) {
      return Icon(Icons.battery_2_bar);
    } else if (percentage > batteryPercentagePart * 1) {
      return Icon(Icons.battery_1_bar);
    } else {
      return Icon(Icons.battery_0_bar);
    }
  }
}
