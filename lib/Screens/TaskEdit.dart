import 'package:clean_launcher/Base/TaskBase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
      time = widget.task!.time;
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
    int hour = time.hour;
    int minute = time.minute;
    NumberFormat nf = new NumberFormat("00");
    return Center(
      child: InkWell(
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
          padding: EdgeInsets.all(24),
          child: Text(
            "Horário: ${nf.format(hour)}:${nf.format(minute)}",
            style: GoogleFonts.montserrat(
                fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(100)),
        ),
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
