import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/screens/notes.dart';
import '../model/todo.dart';
import '../constans/colors.dart';
import '../widgets/todo_items.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  final _box = Hive.box<ToDo>('Todos');
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    _updateToDoList();
  }

  void _updateToDoList() {
    setState(() {
      _foundToDo = _box.values.toList();
    });
  }

  _sortNotes(List<ToDo> todos) {
    if (sorted) {
      todos.sort((a, b) => a.id!.compareTo(b.id!));
    } else {
      todos.sort((b, a) => a.id!.compareTo(b.id!));
    }
    sorted = !sorted;
    return todos;
  }

  void _runFilter(String enterKeyWorkd) {
    List<ToDo> results = [];
    if (enterKeyWorkd.isEmpty) {
      results = _box.values.toList();
    } else {
      results = _box.values
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enterKeyWorkd.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            child: const Text(
                              "All ToDos",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Notes()));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: blue,
                                    minimumSize: const Size(60, 60),
                                    elevation: 10),
                                child: const Icon(
                                  Icons.note_add_sharp,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                      for (ToDo todos in _foundToDo.reversed)
                        TodoItem(
                          todo: todos,
                          onToDoChanged: _handleToDoChallenge,
                          onDeleteItem: _deteleToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: "Add a new ToDo item",
                        border: InputBorder.none),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        minimumSize: const Size(60, 60),
                        elevation: 10),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChallenge(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _box.put(todo.id, todo);
      _updateToDoList(); // Listeyi güncelle
    });
  }

  void _deteleToDoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
      _box.delete(id); // Veriyi Hive kutusundan sil
      _updateToDoList(); // Listeyi güncelle
    });
  }

  void _addToDoItem(String todo) {
    final newToDo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: todo);
    setState(() {
      _box.put(newToDo.id, newToDo); // Veriyi Hive kutusuna ekle
      _updateToDoList(); // Listeyi güncelle
    });
    _todoController.clear();
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: grey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _foundToDo = _sortNotes(_foundToDo);
                });
              },
              icon: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.sort,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }
}
