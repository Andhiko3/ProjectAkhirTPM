import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TicketHistoryService {

  static const String key =
      "ticket_history_username";

  static Future<void> saveTicket(
      Map<String, dynamic> ticket) async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> history =
        prefs.getStringList(key) ?? [];

    history.add(
      jsonEncode(ticket),
    );

    await prefs.setStringList(
      key,
      history,
    );
  }

  static Future<List<Map<String, dynamic>>>
      getHistory() async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> history =
        prefs.getStringList(key) ?? [];

    return history
        .map(
          (e) => jsonDecode(e),
        )
        .cast<Map<String, dynamic>>()
        .toList();
  }
}