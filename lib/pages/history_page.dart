import 'package:flutter/material.dart';
import '../services/ticket_history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() =>
      _HistoryPageState();
}

class _HistoryPageState
    extends State<HistoryPage> {

  List<Map<String, dynamic>>
      history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {

  final data =
      await TicketHistoryService.getHistory();

  print("HISTORY = $data");

  setState(() {
    history = data;
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
      body: history.isEmpty
          ? const Center(
              child: Text(
                "No Ticket History",
              ),
            )
          : ListView.builder(
              itemCount:
                  history.length,
              itemBuilder:
                  (context, index) {

                final ticket =
                    history[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    10,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.movie,
                    ),
                    title: Text(
                      ticket["movie"] ??
                          "-",
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          "Seat: ${ticket["seat"]}",
                        ),
                        Text(
                          "Time: ${ticket["time"]}",
                        ),
                        Text(
                          "Code: ${ticket["code"]}",
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