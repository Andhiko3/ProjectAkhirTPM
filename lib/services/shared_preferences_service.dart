import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import 'dart:convert';

class SharedPreferencesService {
  static const String _keyUsername = 'username';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyFavorites = 'favorites';

  Future<void> saveLoginData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<void> addFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.add(movie);
    await prefs.setString(_keyFavorites, jsonEncode(favorites.map((m) => m.toJson()).toList()));
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.removeWhere((movie) => movie.id == id);
    await prefs.setString(_keyFavorites, jsonEncode(favorites.map((m) => m.toJson()).toList()));
  }

  Future<List<Movie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_keyFavorites);
    if (favoritesJson == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(favoritesJson);
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((movie) => movie.id == id);
  }
}
