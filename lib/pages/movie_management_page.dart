import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/ticket_history_service.dart';
import '../models/movie.dart';

class MovieManagementPage extends StatefulWidget {
  const MovieManagementPage({super.key});

  @override
  State<MovieManagementPage> createState() =>
      _MovieManagementPageState();
}

class _MovieManagementPageState
    extends State<MovieManagementPage> {

  List<Movie> movies = [];

  Map<String, int> soldTickets = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    setState(() {
      isLoading = true;
    });

    final movieData =
        await ApiService.getMovies();

    final ticketData =
        await TicketHistoryService.getHistory();

    Map<String, int> tempSold = {};

    for (var ticket in ticketData) {

      final movieName =
          ticket["movie"]?.toString() ?? "";

      if (movieName.isNotEmpty) {

        tempSold[movieName] =
            (tempSold[movieName] ?? 0) + 1;
      }
    }

    setState(() {
      movies = movieData;
      soldTickets = tempSold;
      isLoading = false;
    });
  }

  Future<void> refreshPage() async {
    await loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Movie Management",
        ),
        actions: [

          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: refreshPage,
          ),
        ],
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : RefreshIndicator(

              onRefresh: refreshPage,

              child: ListView.builder(

                itemCount: movies.length,

                itemBuilder:
                    (context, index) {

                  final movie =
                      movies[index];

                  final totalSold =
                      soldTickets[
                              movie.title] ??
                          0;

                  return Card(

                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    child: ListTile(

                      leading: CircleAvatar(
                        child: Text(
                          "${index + 1}",
                        ),
                      ),

                      title: Text(
                        movie.title,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          const SizedBox(
                              height: 4),

                          Text(
                            "Genre : ${movie.genre.join(", ")}",
                          ),

                          Text(
                            "Rating : ${movie.rating}",
                          ),

                          Text(
                            "Tickets Sold : $totalSold",
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {

                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Edit movie coming soon",
                                  ),
                                ),
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {

                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Delete movie coming soon",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}