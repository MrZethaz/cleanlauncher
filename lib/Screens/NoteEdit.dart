import 'package:clean_launcher/Base/NotesBase.dart';
import 'package:flutter/material.dart';

class NoteEdit extends StatefulWidget {
  NotesBase? note;

  NoteEdit({this.note});

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _contentEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      _titleEditingController.text = widget.note!.title;
      _contentEditingController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  _getBody() {
    return _getContentTextField();
  }

  _getTitleTextField() {
    return TextField(
      decoration: InputDecoration(border: InputBorder.none, hintText: "Título"),
      controller: _titleEditingController,
    );
  }

  _getContentTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Conteúdo",
        ),
        style: TextStyle(fontSize: 20),
        maxLines: 9999999999999,
        controller: _contentEditingController,
      ),
    );
  }

  _getAppBar() {
    return AppBar(title: _getTitleTextField(), actions: [
      IconButton(onPressed: _save, icon: Icon(Icons.save)),
      IconButton(onPressed: _discard, icon: Icon(Icons.cancel_rounded))
    ]);
  }

  _save() {
    if (_titleEditingController.text.isNotEmpty &&
        _contentEditingController.text.isNotEmpty) {
      NotesBase note = NotesBase(
          title: _titleEditingController.text,
          content: _contentEditingController.text,
          lastTimeEditedInMilisseconds: DateTime.now().millisecondsSinceEpoch);
      Navigator.pop(context, note);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fill all fields")));
    }
  }

  _discard() {
    Navigator.pop(context);
  }
}
