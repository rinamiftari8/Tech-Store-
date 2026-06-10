import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../notifications/viewmodels/notification_view_model.dart';
import '../viewmodels/task_view_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _controller = TextEditingController();
  String _priority = 'Medium';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskViewModel>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Warranty & service tasks', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'New task',
                    prefixIcon: Icon(Icons.task_alt_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: const [
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'High', child: Text('High')),
                  ],
                  onChanged: (value) => setState(() => _priority = value ?? 'Medium'),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;
                    context.read<TaskViewModel>().addTask(
                          _controller.text.trim(),
                          _priority,
                          DateTime.now().add(const Duration(days: 2)),
                        );
                    context.read<NotificationViewModel>().push(
                          title: 'Task added',
                          message: _controller.text.trim(),
                          type: 'Task',
                        );
                    _controller.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task added.')),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add task'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...vm.tasks.map(
          (task) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: CheckboxListTile(
                value: task.isDone,
                onChanged: (_) => context.read<TaskViewModel>().toggleTask(task.id),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text('${task.priority} priority • Due ${DateFormat('dd MMM').format(task.dueDate)}'),
                secondary: CircleAvatar(
                  backgroundColor: task.priority == 'High' ? AppColors.warning.withOpacity(.2) : AppColors.lightGreen,
                  child: Icon(
                    task.isDone ? Icons.check_rounded : Icons.schedule_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
