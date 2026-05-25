import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {

  static Future init() async {

    await Hive.initFlutter();

    await Hive.openBox('movieBox');
  }
}
