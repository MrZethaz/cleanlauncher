import 'dart:convert';

class NotesBase {
  String title;
  String content;
  int lastTimeEditedInMilisseconds;

  NotesBase(
      {required this.title,
      required this.content,
      required this.lastTimeEditedInMilisseconds});

  factory NotesBase.fromJson(String json) {
    Map<String, dynamic> jsonMap = jsonDecode(json);

    return NotesBase(
        title: jsonMap["title"],
        content: jsonMap["content"],
        lastTimeEditedInMilisseconds: jsonMap["lastTime"]);
  }

  factory NotesBase.fromMap(Map<String, dynamic> map) {
    return NotesBase(
        title: map["title"],
        content: map["content"],
        lastTimeEditedInMilisseconds: map["lastTime"]);
  }

  String toJson() {
    Map<String, dynamic> notesMap = {
      "title": this.title,
      "content": this.content,
      "lastTime": this.lastTimeEditedInMilisseconds
    };

    String notesJson = jsonEncode(notesMap);
    return notesJson;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> notesMap = {
      "title": this.title,
      "content": this.content,
      "lastTime": this.lastTimeEditedInMilisseconds
    };
    return notesMap;
  }
}
