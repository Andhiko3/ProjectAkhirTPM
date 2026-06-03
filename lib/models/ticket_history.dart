import 'package:flutter/material.dart';
import '../services/ticket_history_service.dart';

class TicketHistoryPage
    extends StatefulWidget {

  const TicketHistoryPage({
    super.key,
  });

  @override
  State<TicketHistoryPage>
      createState() =>
      _TicketHistoryPageState();
}

class _TicketHistoryPageState
    extends State<TicketHistoryPage> {

  List<Map<String,dynamic>>
      tickets = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {

    tickets =
        await TicketHistoryService
            .getHistory();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ticket History",
        ),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context,index){

          final ticket =
              tickets[index];

          return Card(
            child: ListTile(
              title:
              Text(ticket['movie']),
              subtitle:
              Text(
              "Seat : ${ticket['seat']}"
              ),
              trailing:
              Text(ticket['code']),
            ),
          );
        },
      ),
    );
  }
}