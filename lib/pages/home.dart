import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart'; // Для HapticFeedback (опціонально)
import 'package:vibration/vibration.dart'; // Для плагіна vibration
import '../models/task_model.dart';
import '../storage/firestore_storage.dart';
import 'settings.dart';
import 'help.dart';
import 'trash.dart';
import 'home_ui.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String selectedPriority = 'Всі';
  String selectedStatus = 'Всі';
  bool isGridView = false;
  String searchQuery = ""; // Зберігаємо текст пошуку для фільтрації
  bool _confirmDelete = true; // Параметр для підтвердження видалення
  bool _vibrationEnabled = true; // Новий параметр для вібрації

  final List<String> priorities = ['Всі', 'Високий', 'Середній', 'Низький'];
  final List<String> statuses = ['Всі', 'В процесі', 'Завершено', 'Очікує'];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _addTask() {
    String newTask = "";
    String priority = 'Середній';
    String status = 'В процесі';

    if (_vibrationEnabled) {
      Vibration.vibrate(duration: 200); // Вібрація при відкритті діалогу
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Додати нотатку', style: TextStyle(color: Colors.lime)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => newTask = value,
                decoration: InputDecoration(
                  hintText: 'Введіть опис задачі',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: priority,
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Оберіть пріоритет',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                items: priorities
                    .where((e) => e != 'Всі')
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status,
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Оберіть статус',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                items: statuses
                    .where((e) => e != 'Всі')
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() => status = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Скасувати',
                  style: TextStyle(color: Colors.lime, fontWeight: FontWeight.bold),
                )),
            ElevatedButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  final newItem = Task(
                    id: Uuid().v4(),
                    text: newTask,
                    priority: priority,
                    status: status,
                  );
                  FirestoreStorage.addTask(newItem);
                  if (_vibrationEnabled) {
                    Vibration.vibrate(duration: 200); // Вібрація при додаванні
                  }
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                'Додати',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editTask(Task task) {
    final textController = TextEditingController(text: task.text);
    String updatedPriority = task.priority;
    String updatedStatus = task.status;

    if (_vibrationEnabled) {
      Vibration.vibrate(duration: 200); // Вібрація при відкритті діалогу
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Редагувати нотатку', style: TextStyle(color: Colors.lime)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Введіть опис задачі',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: updatedPriority,
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Оберіть пріоритет',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                items: priorities
                    .where((p) => p != 'Всі')
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) {
                  setState(() => updatedPriority = value!);
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: updatedStatus,
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Оберіть статус',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                items: statuses
                    .where((s) => s != 'Всі')
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  setState(() => updatedStatus = value!);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
                textStyle: TextStyle(fontSize: 14),
              ),
              child: Text(
                'Скасувати',
                style: TextStyle(color: Colors.lime, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  final updatedTask = Task(
                    id: task.id,
                    text: textController.text,
                    priority: updatedPriority,
                    status: updatedStatus,
                  );
                  FirestoreStorage.updateTask(updatedTask);
                  if (_vibrationEnabled) {
                    Vibration.vibrate(duration: 200); // Вібрація при редагуванні
                  }
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lime,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                'Зберегти',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task) async {
    if (_confirmDelete) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[850], // Темний фон, як у додатку
          title: Text(
            'Підтвердити видалення',
            style: TextStyle(color: Colors.lime), // Акцентний колір для заголовка
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Колір тексту кнопки
                textStyle: TextStyle(fontWeight: FontWeight.bold), // Жирний текст
              ),
              child: Text('Ні'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lime, // Акцентний колір кнопки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Так',
                style: TextStyle(
                  color: Colors.black, // Темний текст на яскравій кнопці
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirm ?? false) {
        if (_vibrationEnabled) {
          Vibration.vibrate(duration: 200); // Вібрація при підтвердженні видалення
        }
        FirestoreStorage.addToTrash(task);
        FirestoreStorage.deleteTask(task.id);
      }
    } else {
      if (_vibrationEnabled) {
        Vibration.vibrate(duration: 200); // Вібрація при видаленні без підтвердження
      }
      FirestoreStorage.addToTrash(task);
      FirestoreStorage.deleteTask(task.id);
    }
  }

  void _performSearch() {
    setState(() {
      searchQuery = _searchController.text; // Оновлюємо searchQuery при натисканні кнопки
    });
    _searchFocusNode.unfocus(); // Закриваємо клавіатуру після пошуку
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список справ'),
        backgroundColor: Colors.lime,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: isGridView ? 'Список' : 'Сітка',
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.lime),
                child: Text(
                  'Меню',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              HomeUI.buildMenuItem(
                context: context,
                icon: Icons.settings,
                title: 'Налаштування',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(),
                      settings: RouteSettings(
                        arguments: {
                          'confirmDelete': _confirmDelete,
                          'vibrationEnabled': _vibrationEnabled,
                        }, // Передаємо обидва значення
                      ),
                    ),
                  );
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      _confirmDelete = result['confirmDelete'] ?? _confirmDelete;
                      _vibrationEnabled = result['vibrationEnabled'] ?? _vibrationEnabled;
                    });
                  }
                },
              ),
              HomeUI.buildMenuItem(
                context: context,
                icon: Icons.delete,
                title: 'Кошик',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TrashPage()),
                ),
              ),
              HomeUI.buildMenuItem(
                context: context,
                icon: Icons.help,
                title: 'Допомога',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HelpPage()),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: FirestoreStorage.streamTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Помилка: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          }
          final tasks = snapshot.data ?? [];
          print('Received tasks: ${tasks.length}');

          final filtered = tasks.where((task) {
            final matchesSearch = searchQuery.isEmpty ||
                task.text.toLowerCase().contains(searchQuery.toLowerCase());
            final matchesPriority =
                selectedPriority == 'Всі' || task.priority == selectedPriority;
            final matchesStatus =
                selectedStatus == 'Всі' || task.status == selectedStatus;
            return matchesSearch && matchesPriority && matchesStatus;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          // Ніякого setState тут, просто зберігаємо текст у контролері
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Пошук...',
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.white54),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                searchQuery = ''; // Очищаємо пошук
                              });
                            },
                          )
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.lime),
                      onPressed: _performSearch, // Виклик пошуку при натисканні кнопки
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                  child: Text(
                    'Нічого не знайдено',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
                    : isGridView
                    ? GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final task = filtered[index];
                    return HomeUI.buildGridItem(task, _editTask);
                  },
                )
                    : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final task = filtered[index];
                    return HomeUI.buildListItem(
                        task, _editTask, _deleteTask);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lime,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: _addTask,
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}