import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  Future<ParseUser?> login(String email, String password) async {
    final user = ParseUser(email, password, null);
    final response = await user.login();
    if (response.success) {
      return user;
    } else {
      throw Exception(response.error?.message ?? 'Login failed');
    }
  }

  Future<ParseUser?> signUp(String email, String password) async {
    final user = ParseUser(email, password, null);
    final response = await user.signUp();
    if (response.success) {
      return user;
    } else {
      throw Exception(response.error?.message ?? 'Sign-up failed');
    }
  }
}
