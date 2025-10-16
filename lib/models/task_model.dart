class Task {
  final String id;
  final String text;
  final String priority;
  final String status;

  Task({
    required this.id,
    required this.text,
    required this.priority,
    required this.status,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String? ?? 'unknown_id',
      text: map['text'] as String? ?? 'No text',
      priority: map['priority'] as String? ?? 'Середній',
      status: map['status'] as String? ?? 'В процесі',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'priority': priority,
      'status': status,
    };
  }
}