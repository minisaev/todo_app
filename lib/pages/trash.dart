import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../storage/firestore_storage.dart';

class TrashPage extends StatefulWidget {
  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  void _restoreTask(Task task) {
    FirestoreStorage.addTask(task);
    FirestoreStorage.deleteFromTrash(task.id);
  }

  void _deleteForever(Task task) {
    FirestoreStorage.deleteFromTrash(task.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кошик'),
        backgroundColor: Colors.lime,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () async {
              final trash = await FirestoreStorage.loadTrash();
              for (var task in trash) {
                await FirestoreStorage.deleteFromTrash(task.id);
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black87,
        child: StreamBuilder<List<Task>>(
          stream: FirestoreStorage.streamTrash(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Помилка: ${snapshot.error}', style: TextStyle(color: Colors.white)));
            }
            final trash = snapshot.data ?? [];
            return trash.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_outline, // Велика іконка мусорника
                    size: 100,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Кошик порожній",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: trash.length,
              itemBuilder: (context, index) {
                final task = trash[index];
                return Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(task.text, style: TextStyle(color: Colors.white)),
                    subtitle: Text("Статус: ${task.status}", style: TextStyle(color: Colors.white60)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.restore, color: Colors.green),
                          onPressed: () => _restoreTask(task),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteForever(task),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}