class Task {
  final String id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, this.completed = false});

  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }
}
