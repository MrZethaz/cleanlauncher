import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:clean_launcher/Base/TaskBase.dart';
import 'package:clean_launcher/Base/TaskManager.dart';
import 'package:clean_launcher/Screens/NotesList.dart';
import 'package:clean_launcher/Screens/TaskList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

TaskManager tasksManager = TaskManager();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<DateTime> time = ValueNotifier<DateTime>(DateTime.now());
  NumberFormat formatter = new NumberFormat("00");
  var battery = Battery();

  int percentage = 0;
  ValueNotifier<String> cumprimento = ValueNotifier<String>("Bom dia Apollo!");

  List<TaskBase> localTasks = [];
  TaskBase? nextTask;
  _getTasks() async {
    await tasksManager.start();
    await tasksManager.getSharedPreferencesTasks();
    setState(() {
      localTasks = tasksManager.allTasks;
    });
  }

  _getNextTask() {
    localTasks.sort((a, b) {
      int atimestamp = (a.time.hour * 60) + a.time.minute;
      int btimestamp = (b.time.hour * 60) + b.time.minute;
      return atimestamp.compareTo(btimestamp);
    });
    print("dak");
    TimeOfDay timeofday = TimeOfDay.now();
    bool canRun = true;
    for (TaskBase task in localTasks) {
      if ((task.time.hour * 60) + task.time.minute >
              (timeofday.hour * 60) + timeofday.minute &&
          canRun) {
        print("s");
        setState(() {
          nextTask = task;
        });
        canRun = false;
        break;
      } else {
        setState(() {
          nextTask = localTasks[0];
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTasks();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    getBatteryPerentage();
    updateTime();
    updateNextTask();
  }

  void getBatteryPerentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  updateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      time.notifyListeners();
      time.value = DateTime.now();
      if (time.value.hour < 6) {
        cumprimento.value = "Boa madrugada Apollo!";
      } else if (time.value.hour < 12) {
        cumprimento.value = "Bom dia Apollo!";
      } else if (time.value.hour < 18) {
        cumprimento.value = "Boa tarde Apollo!";
      } else if (time.value.hour < 24) {
        cumprimento.value = "Boa noite Apollo!";
      } else {
        cumprimento.value = "Bom dia Apollo!";
      }
    });
  }

  updateNextTask() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      _getNextTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    _getNextTask();
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: Container()),
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
          SizedBox(
            height: 64,
          ),
          ValueListenableBuilder(
            valueListenable: cumprimento,
            builder: (context, value, child) {
              return Text(
                "${cumprimento.value}",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: time,
            builder: (context, value, child) {
              return Text(
                "${formatter.format(time.value.hour)}:${formatter.format(time.value.minute)}:${formatter.format(time.value.second)}",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 64,
                ),
              );
            },
          ),
          ValueListenableBuilder(
              valueListenable: time,
              builder: (context, value, child) {
                return Text(
                  "${formatter.format(time.value.day)}/${formatter.format(time.value.month)}/${time.value.year}",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                );
              }),
          SizedBox(
            height: 36,
          ),
          SizedBox(
            height: 16,
          ),
          nextTask != null
              ? Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "${nextTask!.title.length >= 15 ? nextTask!.title.substring(0, 15) : nextTask!.title}${nextTask!.title.length >= 15 ? "..." : ""}\nas ${formatter.format(nextTask!.time.hour)}:${formatter.format(nextTask!.time.minute)}",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 36,
          ),
          GestureDetector(
            child: Container(
                width: 200,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32)),
                child: Center(
                  child: Text(
                    "Notes",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return NotesList();
                },
              ));
            },
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            child: Container(
                width: 200,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(32)),
                child: Center(
                  child: Text(
                    "Daily tasks",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TaskList();
                },
              ));
            },
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
