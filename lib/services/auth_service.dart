import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.236.44.22:3000';

  // =========================
  // REGISTER
  // =========================

  static Future register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // LOGIN
  // =========================

  static Future login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================
  // SAVE TOKEN
  // =========================

  static Future saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
  }

  // =========================
  // GET TOKEN
  // =========================

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  // =========================
  // LOGOUT
  // =========================

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('isLogin');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('role');
  }
}
