import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({super.key, required this.task, required this.onDelete});

  Future<void> deleteTask() async {
    try {
      await TaskService().deleteTask(task.id!);
      onDelete();
    } catch (e) {
      // Handle deletion error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Due: ${task.dueDate.toLocal().toShortDateString()}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: deleteTask,
        ),
        onTap: () {
          // Optionally toggle completion state
        },
      ),
    );
  }
}

extension DateFormatExtension on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}
