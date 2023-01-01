import 'dart:ffi';

import 'package:clean_launcher/Base/NotesBase.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesManager {
  late SharedPreferences sh;
  late EncryptedSharedPreferences esh;

  List<NotesBase> allNotes = [];

  start() async {
    await _initSharedPreferences();
  }

  _initSharedPreferences() async {
    sh = await SharedPreferences.getInstance();
    esh = EncryptedSharedPreferences(
        mode: AESMode.ofb64Gctr,
        prefs: sh,
        randomKeyKey:
            r"5BzvNj9WqZNk5H7@Ikw!IwGs#KBzZ7!WY@8bHbcPd38n8JC8T(pf@tt(CCf%8W7J",
        randomKeyListKey:
            r"GB^Nr(VDDu5*9qqGNnIUDX*xFTtHyyTZjEhLxZ%G9$wqmEf3g@Rk&cRxEsxhH3tH");
  }

  Future<bool> getSharedPreferencesNotes() async {
    String? notesJson = await esh.getString("notes");

    if (notesJson != null) {
      List<String> notesString =
          (jsonDecode(notesJson) as List).map((e) => e.toString()).toList();
      print(notesString);
      allNotes = notesString
          .map(
              (e) => NotesBase.fromJson(String.fromCharCodes(base64.decode(e))))
          .toList();
      print(allNotes.toString());

      return true;
    } else {
      return false;
    }
  }

  saveNotes({required List<NotesBase> notestosave}) async {
    List<String> notesJsonList =
        allNotes.map((e) => base64.encode(e.toJson().codeUnits)).toList();
    String notesJson = json.encode(notesJsonList);
    await esh.setString("notes", notesJson);
  }
}
