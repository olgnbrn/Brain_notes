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
    'Tamamlananlar': [],
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
      if (todo.isDone) {
        // Tamamlanan görevi mevcut kategoriden çıkar ve 'Tamamlananlar' kategorisine ekle
        categorizedTodos[selectedCategory]?.remove(todo);
        categorizedTodos['Tamamlananlar']?.add(todo);
      } else {
        // Tamamlanmamış görevi 'Tamamlananlar' kategorisinden çıkar ve mevcut kategoriye ekle
        categorizedTodos['Tamamlananlar']?.remove(todo);
        categorizedTodos[selectedCategory]?.add(todo);
      }
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categorizedTodos.keys.map((String category) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                      selected: selectedCategory == category,
                      selectedColor: Colors.lightBlue,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categorizedTodos[selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final todo = categorizedTodos[selectedCategory]![index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _deleteTodo(todo.id);
                  },
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
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
