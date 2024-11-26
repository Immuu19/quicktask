import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Parse().initialize(
    'YOUR_APP_ID', // Replace with Back4App App ID
    'https://parseapi.back4app.com',
    clientKey: 'YOUR_CLIENT_KEY', // Replace with Back4App Client Key
    autoSendSessionId: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickTask',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/tasks': (context) => const TaskListScreen(),
        '/addTask': (context) => const AddTaskScreen(),
      },
    );
  }
}
