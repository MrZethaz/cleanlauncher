import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime time = DateTime.now();
  var battery = Battery();

  int percentage = 0;
  String cumprimento = "Bom dia Apollo!";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getBatteryPerentage();
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
        if (time.hour < 6) {
          cumprimento = "Boa madrugada Apollo!";
        } else if (time.hour < 12) {
          cumprimento = "Bom dia Apollo!";
        } else if (time.hour < 18) {
          cumprimento = "Boa tarde Apollo!";
        } else if (time.hour < 24) {
          cumprimento = "Boa noite Apollo!";
        } else {
          cumprimento = "Bom dia Apollo!";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    updateTime();

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
            "${formatter.format(DateTime.now().hour)}:${formatter.format(DateTime.now().minute)}:${formatter.format(DateTime.now().second)}",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          Text(
            "${formatter.format(DateTime.now().day)}/${formatter.format(DateTime.now().month)}/${DateTime.now().year}",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 64,
          ),
          Text(
            "${cumprimento}",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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
