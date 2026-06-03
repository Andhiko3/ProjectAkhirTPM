import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket_model.dart';

class TicketService {
  static const String key = "tickets";

  static Future<void> saveTicket(
      TicketModel ticket) async {
    final prefs =
        await SharedPreferences.getInstance();

    List<String> tickets =
        prefs.getStringList(key) ?? [];

    tickets.add(
      jsonEncode(ticket.toJson()),
    );

    await prefs.setStringList(
      key,
      tickets,
    );
  }

  static Future<List<TicketModel>>
      getTickets() async {
    final prefs =
        await SharedPreferences.getInstance();

    List<String> tickets =
        prefs.getStringList(key) ?? [];

    return tickets
        .map(
          (e) => TicketModel.fromJson(
            jsonDecode(e),
          ),
        )
        .toList();
  }
}