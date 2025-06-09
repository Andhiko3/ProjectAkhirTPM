import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/favorite_service.dart';
import '../widgets/movie_card.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Movie> favoriteMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    final favorites = await FavoriteService.getFavorites();
    setState(() {
      favoriteMovies = favorites;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.favorite_rounded, 
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Favorite Movies',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade800.withOpacity(0.95),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
            onRefresh: loadFavorites,
            color: Colors.blue.shade600,
            backgroundColor: Colors.white,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
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
              'Loading favorites...',
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

    if (favoriteMovies.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.favorite_border_rounded,
                  size: 64,
                  color: Colors.blue.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Favorite Movies Yet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Start exploring movies and add them to your favorites by tapping the heart icon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.explore_rounded),
                label: const Text('Explore Movies'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blue.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Favorites',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${favoriteMovies.length} movie${favoriteMovies.length != 1 ? 's' : ''} saved',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(movieId: movie.id),
                      ),
                    );
                    loadFavorites();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
