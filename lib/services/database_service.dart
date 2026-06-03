import 'package:hive/hive.dart';

class DatabaseService {

  static Future<void> saveMovie(
      String title) async {

    final box =
        await Hive.openBox(
      'movies',
    );

    await box.add(title);
  }

  static Future<List> getMovies() async {

    final box =
        await Hive.openBox(
      'movies',
    );

    return box.values.toList();
  }
}