import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Допомога', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lime,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black87,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ласкаво просимо до застосунку!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Розділ 1: Функціонал
              _buildSection(
                title: 'Функціонал застосунку',
                icon: Icons.info_outline,
                children: [
                  _buildFeatureItem(
                    'Додавання завдання',
                    'Натисніть кнопку "+" у правому нижньому куті, введіть текст, виберіть пріоритет і статус, потім збережіть.',
                    Icons.add_task,
                  ),
                  _buildFeatureItem(
                    'Редагування завдання',
                    'Натисніть на завдання в списку або сітці, внесіть зміни в текст, пріоритет або статус, і збережіть.',
                    Icons.edit,
                  ),
                  _buildFeatureItem(
                    'Видалення завдання',
                    'Змахніть завдання вліво в списку або натисніть іконку видалення в сітці/списку, щоб перемістити до кошика.',
                    Icons.delete,
                  ),
                  _buildFeatureItem(
                    'Фільтрація завдань',
                    'Використовуйте поле пошуку або виберіть пріоритет і статус у випадаючих списках для фільтрації.',
                    Icons.filter_alt,
                  ),
                  _buildFeatureItem(
                    'Кошик',
                    'Перейдіть у меню "Кошик", щоб відновити видалені завдання або видалити їх назавжди.',
                    Icons.delete_outline,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Розділ 2: Популярні питання
              _buildSection(
                title: 'Популярні запитання',
                icon: Icons.help_outline,
                children: [
                  _buildFAQItem(
                    'Як додати завдання?',
                    'Натисніть кнопку "+" у правому нижньому куті та заповніть форму з текстом, пріоритетом і статусом.',
                  ),
                  _buildFAQItem(
                    'Що робити, якщо я видалив завдання випадково?',
                    'Відкрийте "Кошик" через меню, знайдіть завдання і натисніть іконку відновлення.',
                  ),
                  _buildFAQItem(
                    'Як змінити вигляд списку?',
                    'Натисніть іконку сітки або списку в правому верхньому куті, щоб переключити між режимами.',
                  ),
                  _buildFAQItem(
                    'Чому деякі завдання не відображаються?',
                    'Перевірте фільтри пошуку або статусів, можливо, вони приховані через налаштування.',
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Розділ 3: Можливі проблеми
              _buildSection(
                title: 'Можливі проблеми',
                icon: Icons.warning_amber,
                children: [
                  _buildIssueItem(
                    'Завдання не зберігаються',
                    'Перевірте підключення до інтернету, оскільки дані зберігаються в Firestore.',
                  ),
                  _buildIssueItem(
                    'Пошук не працює',
                    'Переконайтеся, що введено коректний текст, і натисніть кнопку пошуку для оновлення.',
                  ),
                  _buildIssueItem(
                    'Клавіатура закривається при пошуку',
                    'Це може бути пов’язано з автоматичним оновленням; спробуйте оновити додаток або зверніться до підтримки.',
                  ),
                  _buildIssueItem(
                    'Кошик не відображає видалені завдання',
                    'Перевірте, чи кошик очищений, або спробуйте перезапустити додаток.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.lime, size: 24),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ...children,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Card(
      color: Colors.black54,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      color: Colors.black54,
      child: ListTile(
        title: Text(
          question,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          answer,
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildIssueItem(String problem, String solution) {
    return Card(
      color: Colors.black54,
      child: ListTile(
        leading: Icon(Icons.error, color: Colors.red),
        title: Text(
          problem,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          solution,
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ),
    );
  }
}