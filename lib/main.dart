import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const applicationId = 'cd0uRAditBGbdJmfO0BwPK0w7u5FNMTBv92ykN8n';
  const clientKey = 'nDxwb3nprkIWd2c331iaxi4yKtkKHR3QFgvHM5hu';
  const serverUrl = 'https://parseapi.back4app.com/';

  await Parse().initialize(applicationId, serverUrl, clientKey: clientKey);
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
