import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String initialTitle;
  final DateTime initialDueDate;

  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.initialDueDate,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _dueDate = widget.initialDueDate;
  }

  Future<void> _updateTask() async {
    if (_titleController.text.isEmpty || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all task details')),
      );
      return;
    }

    final task = ParseObject('Task')
      ..objectId = widget.taskId
      ..set('title', _titleController.text)
      ..set('dueDate', _dueDate);

    final response = await task.save();

    if (response.success) {
      Navigator.pop(context, true); // Indicate success to refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error?.message ?? 'Failed to update task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(_dueDate == null
                    ? 'No date chosen!'
                    : 'Due Date: ${_dueDate!.toLocal()}'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  },
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
