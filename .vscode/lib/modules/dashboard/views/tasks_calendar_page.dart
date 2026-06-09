import 'package:flutter/material.dart';

import 'package:tech_store/modules/calendar/viewmodels/calendar_view_model.dart';
import 'package:tech_store/modules/tasks/viewmodels/task_view_model.dart';
import 'package:tech_store/modules/calendar/models/calendar_event.dart';
import 'package:tech_store/modules/tasks/models/task_item.dart';

class TasksCalendarPage extends StatefulWidget {
  const TasksCalendarPage({super.key});

  @override
  State<TasksCalendarPage> createState() => _TasksCalendarPageState();
}

class _TasksCalendarPageState extends State<TasksCalendarPage> {
  final TaskViewModel taskViewModel = TaskViewModel();
  final CalendarViewModel calendarViewModel = CalendarViewModel();

  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();

  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController eventDescriptionController = TextEditingController();

  static const Color primaryGreen = Color(0xFF237452);
  static const Color darkGreen = Color(0xFF0F3F2E);
  static const Color lightGreen = Color(0xFFEAF7F0);

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    eventTitleController.dispose();
    eventDateController.dispose();
    eventTimeController.dispose();
    eventDescriptionController.dispose();
    super.dispose();
  }

  void addTask() {
    if (taskTitleController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      taskViewModel.addTask(
        title: taskTitleController.text.trim(),
        description: taskDescriptionController.text.trim().isEmpty
            ? 'No description added.'
            : taskDescriptionController.text.trim(),
      );

      taskTitleController.clear();
      taskDescriptionController.clear();
    });
  }

  void addEvent() {
    if (eventTitleController.text.trim().isEmpty ||
        eventDateController.text.trim().isEmpty ||
        eventTimeController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      calendarViewModel.addEvent(
        title: eventTitleController.text.trim(),
        date: eventDateController.text.trim(),
        time: eventTimeController.text.trim(),
        description: eventDescriptionController.text.trim().isEmpty
            ? 'No description added.'
            : eventDescriptionController.text.trim(),
      );

      eventTitleController.clear();
      eventDateController.clear();
      eventTimeController.clear();
      eventDescriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<TaskItem> tasks = taskViewModel.allTasks;
    final List<CalendarEvent> events = calendarViewModel.allEvents;

    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: const Text(
          'Tasks & Event Calendar',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          _buildHeaderCard(),
          const SizedBox(height: 18),
          _buildTaskForm(),
          const SizedBox(height: 18),
          _buildTaskList(tasks),
          const SizedBox(height: 22),
          _buildCalendarForm(),
          const SizedBox(height: 18),
          _buildEventList(events),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(26),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.task_alt, color: Colors.white, size: 42),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Task Management & Calendar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${taskViewModel.totalTasks} tasks • ${calendarViewModel.totalEvents} events',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskForm() {
    return _sectionCard(
      title: 'Add new task',
      icon: Icons.checklist_rounded,
      children: <Widget>[
        _inputField(
          controller: taskTitleController,
          label: 'Task title',
          icon: Icons.title_rounded,
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: taskDescriptionController,
          label: 'Task description',
          icon: Icons.description_rounded,
        ),
        const SizedBox(height: 14),
        _mainButton(
          text: 'Add Task',
          icon: Icons.add_task_rounded,
          onPressed: addTask,
        ),
      ],
    );
  }

  Widget _buildTaskList(List<TaskItem> tasks) {
    return _sectionCard(
      title: 'To-Do Management',
      icon: Icons.task_rounded,
      children: tasks.map((TaskItem task) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: task.isCompleted ? const Color(0xFFDDF4E8) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD8EDE3)),
          ),
          child: CheckboxListTile(
            value: task.isCompleted,
            activeColor: primaryGreen,
            onChanged: (_) {
              setState(() {
                taskViewModel.toggleTask(task.id);
              });
            },
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.description),
            secondary: Icon(
              task.isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: primaryGreen,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarForm() {
    return _sectionCard(
      title: 'Add calendar event',
      icon: Icons.calendar_month_rounded,
      children: <Widget>[
        _inputField(
          controller: eventTitleController,
          label: 'Event title',
          icon: Icons.event_rounded,
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: eventDateController,
          label: 'Date, example 2026-06-10',
          icon: Icons.date_range_rounded,
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: eventTimeController,
          label: 'Time, example 14:30',
          icon: Icons.access_time_rounded,
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: eventDescriptionController,
          label: 'Event description',
          icon: Icons.notes_rounded,
        ),
        const SizedBox(height: 14),
        _mainButton(
          text: 'Add Event',
          icon: Icons.add_rounded,
          onPressed: addEvent,
        ),
      ],
    );
  }

  Widget _buildEventList(List<CalendarEvent> events) {
    return _sectionCard(
      title: 'Event Calendar',
      icon: Icons.event_available_rounded,
      children: events.map((CalendarEvent event) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD8EDE3)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.date} • ${event.time}',
                      style: const TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(event.description),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8EDE3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: primaryGreen),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryGreen),
        labelText: label,
        filled: true,
        fillColor: lightGreen,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _mainButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}


