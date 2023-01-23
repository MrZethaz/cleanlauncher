import 'package:clean_launcher/Base/TaskBase.dart';
import 'package:clean_launcher/Base/TaskManager.dart';
import 'package:clean_launcher/Screens/HomePage.dart';
import 'package:clean_launcher/Screens/NoteEdit.dart';
import 'package:clean_launcher/Screens/SplashScreen.dart';
import 'package:clean_launcher/Screens/TaskEdit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskBase> localTasks = [];
  bool loading = true;

  _getTasksManager() {
    setState(() {
      localTasks = tasksManager.allTasks;
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTasksManager();
  }

  @override
  Widget build(BuildContext context) {
    localTasks.sort((a, b) {
      int atimestamp = (a.time.hour * 60) + a.time.minute;
      int btimestamp = (b.time.hour * 60) + b.time.minute;
      return atimestamp.compareTo(btimestamp);
    });

    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');

        //trigger leaving and use own data
        Navigator.pop(context, localTasks);

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [_getAddTask()],
          ),
          body: loading
              ? SplashScreen()
              : localTasks.length == 0
                  ? Center(
                      child: Text("Nenhuma nota ainda",
                          style: GoogleFonts.montserrat(
                              fontSize: 24, fontWeight: FontWeight.w700)),
                    )
                  : ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _dismissible(index);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: localTasks.length)),
    );
    ;
  }

  _getAddTask() {
    return IconButton(
        onPressed: () async {
          var result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return TasksEdit();
            },
          ));
          if (result != null) {
            TaskBase task = result as TaskBase;
            setState(() {
              localTasks.add(task);
            });
            bool done = await tasksManager.saveTasks(taskstosave: localTasks);
          }
        },
        icon: Icon(Icons.add));
  }

  _dismissible(int index) {
    return Dismissible(
      key: ValueKey<int>(DateTime.now().microsecondsSinceEpoch),
      child: _getListTile(index),
      direction: DismissDirection.endToStart,
      background: Container(
          color: Colors.red,
          child: Row(
            children: [
              Expanded(child: Container()),
              Icon(Icons.delete),
              SizedBox(
                width: 16,
              )
            ],
          )),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          localTasks.removeAt(index);
          tasksManager.saveTasks(taskstosave: localTasks);
        }
      },
    );
  }

  _getListTile(int index) {
    NumberFormat nf = NumberFormat("00");
    int hour = tasksManager.allTasks[index].time.hour;
    int minute = tasksManager.allTasks[index].time.minute;
    return ListTile(
      title: Text(tasksManager.allTasks[index].title),
      subtitle:
          Text("Hora de execução: ${nf.format(hour)}:${nf.format(minute)}"),
      onTap: () async {
        var result = await Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return TasksEdit(
              task: tasksManager.allTasks[index],
            );
          },
        ));
        if (result != null) {
          TaskBase task = result as TaskBase;

          setState(() {
            localTasks[index] = task;
          });
          await tasksManager.saveTasks(taskstosave: localTasks);
        }
      },
    );
  }
}
