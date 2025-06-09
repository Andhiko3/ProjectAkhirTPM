class Movie {
  final String id;
  final String title;
  final String poster;
  final double rating;
  final List<String> genre; 
  final String duration;
  final String description;
  final String director;
  final String language;
  final String releaseDate;
  final List<String> cast;
  final double price; // Tambahkan properti price

  Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.rating,
    required this.genre,   
    required this.duration,
    required this.description,
    required this.director,
    required this.language,
    required this.releaseDate,
    required this.cast,
    required this.price, // Tambahkan properti price
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      poster: json['imgUrl'] ?? '',
      rating: (json['rating'] is String)
          ? double.tryParse(json['rating'] ?? '0') ?? 0.0
          : json['rating']?.toDouble() ?? 0.0,
      genre: json['genre'] is List
          ? List<String>.from(json['genre']) 
          : [],  
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
      director: json['director'] ?? '',
      language: json['language'] ?? '',
      releaseDate: json['release_date'] ?? '',
      cast: json['cast'] is List
          ? List<String>.from(json['cast'])  
          : [],  
      price: (json['price'] is String)
          ? double.tryParse(json['price'] ?? '0') ?? 0.0
          : json['price']?.toDouble() ?? 0.0, // Pastikan properti price diambil dari JSON
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imgUrl': poster,
    'rating': rating,
    'genre': genre,
    'duration': duration,
    'description': description,
    'director': director,
    'language': language,
    'release_date': releaseDate,
    'cast': cast,
    'price': price, // Tambahkan properti price
  };
}
