import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/task.dart';

class TaskService {
  Future<List<Task>> getTasks() async {
    final query = QueryBuilder(ParseObject('Task'))
      ..orderByAscending('dueDate');
    final response = await query.query();
    if (response.success) {
      return response.results?.map((e) => Task.fromParseObject(e)).toList() ?? [];
    } else {
      throw Exception(response.error?.message ?? 'Failed to fetch tasks');
    }
  }

  Future<void> addTask(Task task) async {
    final parseObject = task.toParseObject();
    final response = await parseObject.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Failed to add task');
    }
  }

  Future<void> deleteTask(String id) async {
    final parseObject = ParseObject('Task')..objectId = id;
    final response = await parseObject.delete();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Failed to delete task');
    }
  }
}
