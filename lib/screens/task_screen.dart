import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<ParseObject> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final query = QueryBuilder(ParseObject('Task'))..orderByDescending('createdAt');
      final response = await query.query();

      if (response.success && response.results != null) {
        setState(() {
          tasks = response.results as List<ParseObject>;
        });
      } else {
        _showSnackBar(response.error?.message ?? 'Error fetching tasks');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final task = ParseObject('Task')..objectId = taskId;

    try {
      final response = await task.delete();

      if (response.success) {
        setState(() {
          tasks.removeWhere((task) => task.objectId == taskId);
        });
        _showSnackBar('Task deleted successfully');
      } else {
        _showSnackBar(response.error?.message ?? 'Failed to delete task');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  Future<void> _toggleTaskStatus(String taskId, bool currentStatus) async {
    final task = ParseObject('Task')
      ..objectId = taskId
      ..set('isCompleted', !currentStatus);

    try {
      final response = await task.save();

      if (response.success) {
        _fetchTasks(); // Refresh tasks after toggling status
      } else {
        _showSnackBar(response.error?.message ?? 'Failed to toggle task status');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTasks,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text('No tasks available'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final title = task.get<String>('title') ?? '';
                    final dueDate = task.get<DateTime>('dueDate')?.toLocal();
                    final completed = task.get<bool>('isCompleted') ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4, // Adding shadow for better visual depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Checkbox(
                          value: completed,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              _toggleTaskStatus(task.objectId!, completed);
                            }
                          },
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            decoration: completed ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: dueDate != null
                            ? Text(
                                'Due: ${dueDate.toString().split(' ')[0]}',
                                style: TextStyle(color: Colors.grey[600]),
                              )
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteTask(task.objectId!);
                          },
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(
                                taskId: task.objectId!,
                                initialTitle: title,
                                initialDueDate: dueDate ?? DateTime.now(),
                              ),
                            ),
                          );

                          if (result == true) {
                            _fetchTasks(); // Refresh tasks after editing
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (result == true) {
            _fetchTasks(); // Refresh tasks after adding a new one
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent, // More visible FAB color
      ),
    );
  }
}
