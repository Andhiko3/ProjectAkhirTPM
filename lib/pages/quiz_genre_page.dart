import 'package:flutter/material.dart';
import 'movie_quiz_page.dart';

class QuizGenrePage extends StatelessWidget {
  const QuizGenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final genres = [
      "Horror",
      "Comedy",
      "Action",
      "Drama",
      "Sci-Fi",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quiz Genre"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: genres.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieQuizPage(
                      genre: genres[index],
                    ),
                  ),
                );
              },
              child: Text(
                genres[index],
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}