import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import '../services/user_service.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  bool isLoading = true;
  String? error;

  String? selectedGenre;
  String? selectedYear;
  double? selectedRating;

  final List<String> genres = ['Action', 'Comedy', 'Drama', 'Horror'];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final movieList = await ApiService.getMovies(
        genre: selectedGenre,
        year: selectedYear,
        rating: selectedRating,
      );
      setState(() {
        movies = movieList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Movie App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade800, // Warna latar belakang AppBar
        actions: [
          // Tombol Favorit
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritePage()),
                );
              },
            ),
          ),
          // Tombol Profil
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile button clicked'),
                  ),
                );
              },
            ),
          ),
          // Tombol Logout
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout button clicked'),
                  ),
                );
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3A8A), 
              Color(0xFF3B82F6), 
              Color(0xFF60A5FA), 
              Color(0xFFDDD6FE), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: loadMovies,
            color: Colors.blue.shade600,
            backgroundColor: Colors.white,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Movies',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find your favorite movies and explore new ones',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                      'Select Genre',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                    value: selectedGenre,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue.shade600),
                    dropdownColor: Colors.white,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'All Genres',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                      ...genres.map((String genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(
                            genre,
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value;
                      });
                      loadMovies();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading movies...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(color: Colors.red.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadMovies,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (movies.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.movie_outlined,
                size: 48,
                color: Colors.blue.shade600,
              ),
              const SizedBox(height: 16),
              Text(
                'No Movies Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters or check back later',
                style: TextStyle(color: Colors.blue.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            movie: movie,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(movieId: movie.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
