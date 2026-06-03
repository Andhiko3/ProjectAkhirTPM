import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feedback_model.dart';

class FeedbackService {
  static const String key = "feedback_data";

  static Future<void> addFeedback(FeedbackModel feedback) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList(key) ?? [];

    data.add(
      jsonEncode(
        feedback.toJson(),
      ),
    );

    await prefs.setStringList(
      key,
      data,
    );
  }

  static Future<List<FeedbackModel>> getFeedbacks() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> data = prefs.getStringList(key) ?? [];

    return data
        .map(
          (e) => FeedbackModel.fromJson(
            jsonDecode(e),
          ),
        )
        .toList();
  }

  static Future<void> deleteFeedback(String id) async {
    final all = await getFeedbacks();

    all.removeWhere(
      (e) => e.id == id,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      key,
      all
          .map(
            (e) => jsonEncode(e.toJson()),
          )
          .toList(),
    );
  }

  static Future<void> updateFeedback(FeedbackModel feedback) async {
    List<FeedbackModel> all = await getFeedbacks();

    final index = all.indexWhere(
      (e) => e.id == feedback.id,
    );

    if (index != -1) {
      all[index] = feedback;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      key,
      all
          .map(
            (e) => jsonEncode(e.toJson()),
          )
          .toList(),
    );
  }
}
