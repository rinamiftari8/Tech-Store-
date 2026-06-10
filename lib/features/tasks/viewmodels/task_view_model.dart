import 'package:flutter/foundation.dart';

import '../models/service_task.dart';

class TaskViewModel extends ChangeNotifier {
  final List<ServiceTask> _tasks = [
    ServiceTask(
      id: 'TSK-1',
      title: 'Check warranty for customer phone',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      isDone: false,
    ),
    ServiceTask(
      id: 'TSK-2',
      title: 'Prepare delivery package',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isDone: true,
    ),
  ];

  List<ServiceTask> get tasks => List.unmodifiable(_tasks);
  int get completedCount => _tasks.where((task) => task.isDone).length;

  void addTask(String title, String priority, DateTime dueDate) {
    _tasks.insert(
      0,
      ServiceTask(
        id: 'TSK-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        priority: priority,
        dueDate: dueDate,
        isDone: false,
      ),
    );
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
    notifyListeners();
  }
}
