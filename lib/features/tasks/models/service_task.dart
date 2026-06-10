class ServiceTask {
  const ServiceTask({
    required this.id,
    required this.title,
    required this.priority,
    required this.dueDate,
    required this.isDone,
  });

  final String id;
  final String title;
  final String priority;
  final DateTime dueDate;
  final bool isDone;

  ServiceTask copyWith({
    String? id,
    String? title,
    String? priority,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return ServiceTask(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
