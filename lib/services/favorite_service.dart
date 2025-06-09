import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import 'user_service.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorite_movies';

  static Future<String> _getUserKey() async {
    final user = await UserService.getLoggedInUser();
    return user != null ? 'favorite_movies_$user' : _favoritesKey;
  }

  static Future<List<Movie>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserKey();
      final String? favoritesJson = prefs.getString(key);

      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        return favoritesList.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<void> addToFavorites(Movie movie) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserKey();
      final favorites = await getFavorites();

      if (!favorites.any((fav) => fav.id == movie.id)) {
        favorites.add(movie);
        final String favoritesJson = json.encode(
          favorites.map((movie) => movie.toJson()).toList(),
        );
        await prefs.setString(key, favoritesJson);
      }
    } catch (e) {
    }
  }

  static Future<void> removeFromFavorites(String movieId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getUserKey();
      final favorites = await getFavorites();

      favorites.removeWhere((movie) => movie.id == movieId);
      final String favoritesJson = json.encode(
        favorites.map((movie) => movie.toJson()).toList(),
      );
      await prefs.setString(key, favoritesJson);
    } catch (e) {
    }
  }

  static Future<bool> isFavorite(String movieId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((movie) => movie.id == movieId);
    } catch (e) {
      return false;
    }
  }
}
