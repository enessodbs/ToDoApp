// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? content;

  @HiveField(3)
  DateTime? date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  static List<Note> noteList() {
    return [];
  }
}
