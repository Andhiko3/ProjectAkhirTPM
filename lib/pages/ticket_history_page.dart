import 'package:flutter/material.dart';
import '../services/ticket_history_service.dart';

class TicketHistoryPage extends StatefulWidget {
  const TicketHistoryPage({super.key});

  @override
  State<TicketHistoryPage> createState() =>
      _TicketHistoryPageState();
}

class _TicketHistoryPageState
    extends State<TicketHistoryPage> {

  List<Map<String, dynamic>> tickets = [];

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    final data =
        await TicketHistoryService.getHistory();

    setState(() {
      tickets = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ticket History",
        ),
      ),

      body: tickets.isEmpty
          ? const Center(
              child: Text(
                "No Ticket History",
              ),
            )
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {

                final ticket =
                    tickets[index];

                return Card(
                  margin:
                      const EdgeInsets.all(10),

                  child: ListTile(
                    leading: const Icon(
                      Icons.movie,
                    ),

                    title: Text(
                      ticket["movie"] ?? "",
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Seat : ${ticket["seat"]}",
                        ),

                        Text(
                          "Show Time : ${ticket["time"]}",
                        ),

                        Text(
                          "Code : ${ticket["code"]}",
                        ),

                        Text(
                          "Price : Rp ${ticket["totalPrice"]}",
                        ),

                        Text(
                          ticket["purchaseDate"] ?? "",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}