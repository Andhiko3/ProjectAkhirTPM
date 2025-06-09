import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String baseUrl = 'https://681388b3129f6313e2119693.mockapi.io/api/v1';

  static Future<List<Movie>> getMovies({String? genre, String? year, double? rating}) async {
    try {
      String query = '';
      if (genre != null) query += 'genre=$genre&';
      if (year != null) query += 'year=$year&';
      if (rating != null) query += 'rating=$rating&';
      query = query.isNotEmpty ? '?' + query.substring(0, query.length - 1) : '';

      final response = await http.get(Uri.parse('$baseUrl/movie$query'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Movie> getMovieById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/movie/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
