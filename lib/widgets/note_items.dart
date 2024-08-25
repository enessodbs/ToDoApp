import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: onTap,
          title: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: note.title!,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: '\n'), // Satır boşluğu ekler
                TextSpan(
                  text: note.content,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(note.date!)}',
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
