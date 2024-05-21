import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  Map<String, List<Todo>> categorizedTodos = {
    'Fitness': [],
    'Eğitim': [],
    'Finansal': [],
    'Sağlık': [],
  };
  String selectedCategory = 'Fitness';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');
    if (todosJson != null) {
      Map<String, dynamic> todosMap = json.decode(todosJson);
      setState(() {
        categorizedTodos = todosMap.map((key, value) {
          var todoList = value as List;
          return MapEntry(key, todoList.map((item) => Todo.fromJson(item)).toList());
        });
      });
    }
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String todosJson = json.encode(categorizedTodos.map((key, value) {
      return MapEntry(key, value.map((todo) => todo.toJson()).toList());
    }));
    await prefs.setString('todos', todosJson);
  }

  void _addTodo() {
    final String id = Uuid().v4();
    if (_titleController.text.isNotEmpty) {
      final todo = Todo(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
      );
      setState(() {
        categorizedTodos[selectedCategory]?.add(todo);
        _saveTodos();
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  void _deleteTodo(String id) {
    setState(() {
      categorizedTodos[selectedCategory]?.removeWhere((todo) => todo.id == id);
      _saveTodos();
    });
  }

  void _toggleDone(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yapılacaklar Listesi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            color: Colors.grey[200],
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categorizedTodos.keys.map((String category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedCategory == category
                            ? Colors.blue
                            : Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categorizedTodos[selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final todo = categorizedTodos[selectedCategory]![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(todo.title, style: TextStyle(fontSize: 18)),
                    subtitle: Text(todo.description),
                    trailing: Checkbox(
                      value: todo.isDone,
                      onChanged: (bool? value) {
                        _toggleDone(todo);
                      },
                    ),
                    onTap: () {
                      // Görev detayları için bir dialog göster
                    },
                    onLongPress: () {
                      _deleteTodo(todo.id);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Görev Başlığı',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Görev Açıklaması',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  ),
                  onPressed: _addTodo,
                  child: Text('Görev Ekle', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  String id;
  String title;
  String description;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'],
    );
  }
}
