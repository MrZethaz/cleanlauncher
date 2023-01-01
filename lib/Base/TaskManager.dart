import 'dart:ffi';

import 'package:clean_launcher/Base/NotesBase.dart';
import 'package:clean_launcher/Base/TaskBase.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskManager {
  late SharedPreferences sh;

  List<TaskBase> allTasks = [];
  start() async {
    await _initSharedPreferences();
  }

  bool checkTasks() {
    return sh.containsKey("tasks");
  }

  _initSharedPreferences() async {
    sh = await SharedPreferences.getInstance();
  }

  Future<bool> getSharedPreferencesTasks() async {
    List<String>? tasksJson = sh.getStringList("tasks");

    if (tasksJson != null) {
      allTasks = tasksJson.map((e) => TaskBase.fromJson(e)).toList();

      return true;
    } else {
      return false;
    }
  }

  saveTasks({required List<TaskBase> taskstosave}) async {
    List<String> tasksJsonList = allTasks.map((e) => e.toJson()).toList();
    await sh.setStringList("tasks", tasksJsonList);
    print("Saved task");
  }
}
