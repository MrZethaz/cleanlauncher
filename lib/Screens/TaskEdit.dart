import 'package:clean_launcher/Base/TaskBase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksEdit extends StatefulWidget {
  TaskBase? task;

  TasksEdit({this.task});

  @override
  State<TasksEdit> createState() => _TasksEditState();
}

class _TasksEditState extends State<TasksEdit> {
  TextEditingController _titleEditingController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      _titleEditingController.text = widget.task!.title;
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
      decoration: InputDecoration(border: InputBorder.none, labelText: "Title"),
      controller: _titleEditingController,
    );
  }

  _getContentTextField() {
    return InkWell(
      onTap: () async {
        TimeOfDay? timePicked =
            await showTimePicker(context: context, initialTime: time);
        if (timePicked != null) {
          setState(() {
            time = timePicked;
          });
        }
      },
      child: Ink(
        padding: EdgeInsets.all(8),
        child: Text(
          "Horário: ${this.time.hour}:${this.time.minute}",
          style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(32)),
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
    if (_titleEditingController.text.isNotEmpty) {
      TaskBase task = TaskBase(title: _titleEditingController.text, time: time);
      Navigator.pop(context, task);
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
