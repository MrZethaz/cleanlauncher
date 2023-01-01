import 'package:clean_launcher/Base/NotesBase.dart';
import 'package:clean_launcher/Base/NotesManager.dart';
import 'package:clean_launcher/Screens/NoteEdit.dart';
import 'package:clean_launcher/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  NotesManager notesManager = NotesManager();
  List<NotesBase> localNotes = [];
  bool loading = true;

  _getNotesManager() async {
    await notesManager.start();
    await notesManager.getSharedPreferencesNotes();
    setState(() {
      localNotes = notesManager.allNotes;
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotesManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [_getAddNote()],
        ),
        body: loading
            ? SplashScreen()
            : localNotes.length == 0
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
                    itemCount: localNotes.length));
  }

  _getAddNote() {
    return IconButton(
        onPressed: () async {
          var result = await Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return NoteEdit();
            },
          ));
          if (result != null) {
            NotesBase note = result as NotesBase;
            setState(() {
              localNotes.add(note);
            });
            bool done = await notesManager.saveNotes(notestosave: localNotes);
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
          localNotes.removeAt(index);
          notesManager.saveNotes(notestosave: localNotes);
        }
      },
    );
  }

  _getListTile(int index) {
    DateTime lastModified = DateTime.fromMillisecondsSinceEpoch(
        localNotes[index].lastTimeEditedInMilisseconds);
    DateFormat format = DateFormat().add_yMMMMEEEEd();
    DateFormat format2 = DateFormat().add_Hms();
    return ListTile(
      title: Text(notesManager.allNotes[index].title),
      subtitle: Text(
          "${format.format(lastModified)} - ${format2.format(lastModified)}"),
      onTap: () async {
        var result = await Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return NoteEdit(
              note: notesManager.allNotes[index],
            );
          },
        ));
        if (result != null) {
          NotesBase note = result as NotesBase;

          setState(() {
            localNotes[index] = note;
          });
          await notesManager.saveNotes(notestosave: localNotes);
        }
      },
    );
  }
}
