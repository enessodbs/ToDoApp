import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/constans/colors.dart';
import 'package:todo_app/screens/edit_note.dart';
import 'package:todo_app/widgets/note_items.dart';
import '../model/note.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late final Note note;
  final _box = Hive.box<Note>('Notes');
  List<Note> _foundNote = [];
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    _updateToDoList();
  }

  void _updateToDoList() {
    setState(() {
      _foundNote = _box.values.toList();
    });
  }

  _sortNotes(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.date!.compareTo(b.date!));
    } else {
      notes.sort((b, a) => a.date!.compareTo(b.date!));
    }
    sorted = !sorted;
    return notes;
  }

  void _runFilter(String enterKeyword) {
    List<Note> results = [];
    if (enterKeyword.isEmpty) {
      results = _box.values.toList(); // Arama kutusu boşsa, tüm notları göster
    } else {
      results = _box.values
          .where((note) =>
              note.content!
                  .toLowerCase()
                  .contains(enterKeyword.toLowerCase()) ||
              note.title!.toLowerCase().contains(enterKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundNote = results;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      note = _foundNote[index];
      _box.delete(note.id); // Belirli bir notu Hive'dan silmek için ID kullan
      _updateToDoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      icon: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      )),
                  const Text(
                    "Notes",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _foundNote = _sortNotes(_foundNote);
                        });
                      },
                      icon: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.sort,
                          color: Colors.black,
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 15),
              searchBox(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 30),
                  itemCount: _foundNote.length,
                  itemBuilder: (context, index) {
                    return NoteItem(
                      note: _foundNote[index],
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditNote(
                              note: _foundNote[index],
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            Note updatedNote = Note(
                              id: _foundNote[index].id,
                              title: result[0],
                              content: result[1],
                              date: DateTime.now(),
                            );

                            _box.put(updatedNote.id, updatedNote);
                            _updateToDoList();
                          });
                        }
                      },
                      onDelete: () async {
                        final result = await confirmDialog(context);
                        if (result != null && result) {
                          _deleteNote(index);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(95, 82, 238, 1),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const EditNote(),
              ),
            );

            if (result != null) {
              setState(() {
                Note newNote = Note(
                  id: _box.length,
                  title: result[0],
                  content: result[1],
                  date: DateTime.now(),
                );

                _box.put(newNote.id, newNote);
                _updateToDoList();
              });
            }
          },
          child: const Text(
            '+',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ));
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            title: const Text(
              "Are you sure you want to delete?",
              style: TextStyle(color: Colors.black),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      "Yes",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      "No",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          );
        });
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => {_runFilter(value)},
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
