// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_app/constans/colors.dart';
import 'package:todo_app/model/note.dart';

class EditNote extends StatefulWidget {
  final Note? note;
  const EditNote({
    super.key,
    this.note,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
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
                    ))
              ],
            ),
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.black, fontSize: 30),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                ),
                TextField(
                  maxLines: null,
                  controller: _contentController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Content",
                      hintStyle: TextStyle(color: Colors.grey)),
                )
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
              context, [_titleController.text, _contentController.text]);
        },
        backgroundColor: blue,
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}
