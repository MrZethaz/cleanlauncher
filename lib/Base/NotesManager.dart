import 'dart:ffi';

import 'package:clean_launcher/Base/NotesBase.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesManager {
  late SharedPreferences sh;

  List<NotesBase> allNotes = [];

  start() async {
    await _initSharedPreferences();
  }

  bool checkNotes() {
    return sh.containsKey("notes");
  }

  _initSharedPreferences() async {
    sh = await SharedPreferences.getInstance();
  }

  Future<bool> getSharedPreferencesNotes() async {
    List<String>? notesJson = sh.getStringList("notes");

    if (notesJson != null) {
      allNotes = notesJson.map((e) => NotesBase.fromJson(e)).toList();

      return true;
    } else {
      return false;
    }
  }

  saveNotes({required List<NotesBase> notestosave}) async {
    List<String> notesJsonList = allNotes.map((e) => e.toJson()).toList();
    await sh.setStringList("notes", notesJsonList);
  }
}
