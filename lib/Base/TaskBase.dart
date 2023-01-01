import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

class TaskBase {
  String title;
  TimeOfDay time;

  TaskBase({
    required this.title,
    required this.time,
  });

  factory TaskBase.fromJson(String json) {
    Map<String, dynamic> jsonMap = jsonDecode(json);

    return TaskBase(
        title: jsonMap["title"],
        time: TimeOfDay(
          hour: int.parse((jsonMap["time"] as String).split("|")[0]),
          minute: int.parse((jsonMap["time"] as String).split("|")[1]),
        ));
  }

  factory TaskBase.fromMap(Map<String, dynamic> map) {
    return TaskBase(
      title: map["title"],
      time: TimeOfDay(
          hour: (map["time"] as String).split("|")[0] as int,
          minute: (map["time"] as String).split("|")[1] as int),
    );
  }

  String toJson() {
    Map<String, dynamic> notesMap = {
      "title": this.title,
      "time": "${this.time.hour}|${this.time.minute}",
    };

    String notesJson = jsonEncode(notesMap);
    return notesJson;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> notesMap = {
      "title": this.title,
      "time": "${this.time.hour}|${this.time.minute}",
    };
    return notesMap;
  }
}
