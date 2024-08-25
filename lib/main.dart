import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screens/splash.dart';

Future<void> main(List<String> args) async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter()); // Model adapterinizi kaydedin
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<ToDo>('Todos');
  await Hive.openBox<Note>('Notes');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      title: "ToDo & Notes",
      home: const SplashScreen(),
    );
  }
}
