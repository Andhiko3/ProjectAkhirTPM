import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'isLogin',
      true,
    );
  }

  static Future<bool> isLogin() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(
          'isLogin',
        ) ??
        false;
  }

  static Future<void> saveLastUser(
    String username,
    String email,
    String role,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "last_username",
      username,
    );

    await prefs.setString(
      "last_email",
      email,
    );

    await prefs.setString(
      "last_role",
      role,
    );
  }

  static Future<void> saveBiometricUser(
    String username,
    String email,
    String role,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "bio_username",
      username,
    );

    await prefs.setString(
      "bio_email",
      email,
    );

    await prefs.setString(
      "bio_role",
      role,
    );
  }

  static Future<Map<String, String?>> getBiometricUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "username": prefs.getString(
        "bio_username",
      ),
      "email": prefs.getString(
        "bio_email",
      ),
      "role": prefs.getString(
        "bio_role",
      ),
    };
  }

  static Future<void> removeBiometricUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      "bio_username",
    );

    await prefs.remove(
      "bio_email",
    );

    await prefs.remove(
      "bio_role",
    );
  }

  static Future<Map<String, String?>> getLastUser() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "username": prefs.getString(
        "last_username",
      ),
      "email": prefs.getString(
        "last_email",
      ),
      "role": prefs.getString(
        "last_role",
      ),
    };
  }

  static Future<void> saveUsername(
    String username,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      "username",
      username,
    );
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      "username",
    );
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('isLogin');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('role');
  }
}
