import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController searchController =
      TextEditingController();

  List<Movie> movies = [];
  List<Movie> filteredMovies = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {

      final data =
          await ApiService.getMovies();

      setState(() {
        movies = data;
        filteredMovies = data;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

    }
  }

  void searchMovie(String keyword) {

    setState(() {

      filteredMovies = movies.where((movie) {

        return movie.title
                .toLowerCase()
                .contains(
                  keyword.toLowerCase(),
                ) ||

            movie.genre.join(",")
                .toLowerCase()
                .contains(
                  keyword.toLowerCase(),
                );

      }).toList();

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Search Movie",
        ),
      ),

      body: Column(

        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(

              controller: searchController,

              onChanged: searchMovie,

              decoration: InputDecoration(

                hintText:
                    "Cari film atau genre",

                prefixIcon:
                    const Icon(Icons.search),

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(

            child: isLoading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : GridView.builder(

                    padding:
                        const EdgeInsets.all(12),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                    ),

                    itemCount:
                        filteredMovies.length,

                    itemBuilder:
                        (context, index) {

                      final movie =
                          filteredMovies[index];

                      return MovieCard(

                        movie: movie,

                        onTap: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  DetailPage(
                                movieId:
                                    movie.id,
                              ),

                            ),

                          );

                        },

                      );

                    },

                  ),

          ),

        ],

      ),

    );

  }

}