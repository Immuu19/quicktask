import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String? id;
  String title;
  DateTime dueDate;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Convert Task to ParseObject
  ParseObject toParseObject() {
    final parseTask = ParseObject('Task');
    if (id != null) parseTask.objectId = id;
    parseTask
      ..set('title', title)
      ..set('dueDate', dueDate.toIso8601String())
      ..set('isCompleted', isCompleted);
    return parseTask;
  }

  // Convert ParseObject to Task
  factory Task.fromParseObject(ParseObject parseObject) {
    return Task(
      id: parseObject.objectId,
      title: parseObject.get<String>('title')!,
      dueDate: DateTime.parse(parseObject.get<String>('dueDate')!),
      isCompleted: parseObject.get<bool>('isCompleted')!,
    );
  }
}
