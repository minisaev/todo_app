import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для HapticFeedback

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _confirmDelete = true; // Параметр для підтвердження видалення
  bool _vibrationEnabled = true; // Новий параметр для вібрації

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Отримуємо поточні значення з Home, якщо вони передані
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _confirmDelete = args['confirmDelete'] ?? true;
      _vibrationEnabled = args['vibrationEnabled'] ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Налаштування",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lime,
      ),
      body: Container(
        color: Colors.black87,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: Text(
                'Підтверджувати видалення',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: _confirmDelete,
                onChanged: (value) {
                  setState(() {
                    _confirmDelete = value;
                  });
                },
                activeColor: Colors.lime,
              ),
            ),
            ListTile(
              title: Text(
                'Увімкнути вібрацію',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _vibrationEnabled = value;
                  });
                  if (value) {
                    HapticFeedback.lightImpact(); // Коротка вібрація при увімкненні
                  }
                },
                activeColor: Colors.lime,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lime,
        child: Icon(Icons.save, color: Colors.black),
        onPressed: () {
          Navigator.pop(context, {
            'confirmDelete': _confirmDelete,
            'vibrationEnabled': _vibrationEnabled,
          }); // Повертаємо обидва значення
        },
      ),
    );
  }
}