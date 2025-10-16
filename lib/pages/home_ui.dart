import 'package:flutter/material.dart';
import '../models/task_model.dart';

class HomeUI {
  static Widget buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  static Widget buildListItem(
      Task task,
      void Function(Task) onEdit,
      void Function(Task) onDelete,
      ) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(task),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black54, width: 1.2),
        ),
        child: ListTile(
          leading: _priorityIndicator(task.priority),
          title: Text(task.text,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text("Статус: ${task.status}",
              style: TextStyle(color: Colors.white70)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.grey),
                onPressed: () => onEdit(task),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.blueGrey),
                onPressed: () => onDelete(task),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildGridItem(
      Task task,
      void Function(Task) onEdit,
      ) {
    return GestureDetector(
      onTap: () => onEdit(task),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black54, width: 1.2),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: _priorityIndicator(task.priority)),
            Expanded(
              child: Text(
                task.text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Статус: ${task.status}",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey, size: 18),
                  onPressed: () => onEdit(task),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.blueGrey, size: 18),
                  onPressed: () => null,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _priorityIndicator(String priority) {
    Color color;
    switch (priority) {
      case 'Високий':
        color = Colors.red;
        break;
      case 'Середній':
        color = Colors.orange;
        break;
      case 'Низький':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle)
    );
  }
}