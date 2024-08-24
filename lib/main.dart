import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screens/splash.dart';

Future<void> main(List<String> args) async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter()); // Model adapterinizi kaydedin
  await Hive.openBox<ToDo>('Todos');
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
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ToDo App",
      home: SplashScreen(),
    );
  }
}
