class Movie {
  final int id;
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
  print("JSON MOVIE:");
  print(json);

  return Movie(
    id: int.tryParse(json['id'].toString()) ?? 0,

    title: json['title']?.toString() ?? '',

    poster: json['imgUrl']?.toString() ?? '',

    rating: double.tryParse(json['rating'].toString()) ?? 0.0,

    genre: json['genre'] is List
        ? List<String>.from(json['genre'])
        : [],

    duration: json['duration']?.toString() ?? '',

    description: json['description']?.toString() ?? '',

    director: json['director']?.toString() ?? '',

    language: json['language']?.toString() ?? '',

    releaseDate: json['release_date']?.toString() ?? '',

    cast: json['cast'] is List
        ? List<String>.from(json['cast'])
        : [],

    price: double.tryParse(json['price'].toString()) ?? 0.0,
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
