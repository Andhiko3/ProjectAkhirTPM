import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../services/ticket_history_service.dart';
import 'history_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/sentiment_service.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class DetailPage extends StatefulWidget {
  final int movieId;

  const DetailPage({
    super.key,
    required this.movieId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Movie? movie;
  bool isLoading = true;
  bool isFavorite = false;
  String? error;

  String selectedCurrencyTo = 'USD';
  final List<String> currencies = ['USD', 'IDR', 'EUR', 'JPY'];
  double inputAmount = 0.0;
  bool isSeatSelected = false;
  bool isTicketPurchased = false;
  List<String> selectedSeats = [];
  String ticketCode = '';
  double ticketPrice = 50000;

  double get totalPrice => selectedSeats.length * ticketPrice;

  final List<String> showTimes = [
    '10:00 AM',
    '01:00 PM',
    '04:00 PM',
    '07:00 PM',
    '10:00 PM',
  ];
  String? selectedShowTime;

  final List<Map<String, dynamic>> seats = List.generate(
    50,
    (index) => {
      'id': '${String.fromCharCode(65 + (index ~/ 10))}${(index % 10) + 1}',
      'isAvailable': true,
      'isSelected': false,
    },
  );

  DateTime currentTime = DateTime.now();
  String selectedTimeZone = 'WIB';

  // Properti untuk kesan dan pesan
  String userFeedback = ''; // Menyimpan kesan dan pesan pengguna

  String sentimentResult = '';
  String sentimentScore = '';

  @override
  void initState() {
    super.initState();
    loadMovieDetail();
    checkFavoriteStatus();
  }

  Future<void> loadMovieDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final movieDetail = await ApiService.getMovieById(widget.movieId);
      print(movieDetail.price);
      setState(() {
        movie = movieDetail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> checkFavoriteStatus() async {
    final favorite = await FavoriteService.isFavorite(widget.movieId);
    setState(() {
      isFavorite = favorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (movie == null) {
      debugPrint('Movie is null');
      return;
    }

    if (isFavorite) {
      await FavoriteService.removeFromFavorites(movie!.id);
      setState(() => isFavorite = false);
      _showSnackbar('Removed from favorites', Colors.red.shade600);
    } else {
      await FavoriteService.addToFavorites(movie!);
      setState(() => isFavorite = true);
      _showSnackbar('Added to favorites', Colors.green.shade600);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      ),
    );
  }

  void _showOverlayNotification(String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  String convertCurrency(double amount, String toCurrency) {
    const exchangeRates = {
      'USD': 1.0,
      'IDR': 15000.0,
      'EUR': 0.85,
      'JPY': 110.0,
    };

    if (!exchangeRates.containsKey(toCurrency)) {
      throw ArgumentError('Unsupported currency: $toCurrency');
    }

    double amountInUSD = amount / exchangeRates['IDR']!;
    double convertedAmount = amountInUSD * exchangeRates[toCurrency]!;
    return convertedAmount.toStringAsFixed(2);
  }

  String _convertTimeZone(DateTime time, String timeZone) {
    final timeZoneOffset = {
      'WIB': const Duration(hours: 7),
      'WITA': const Duration(hours: 8),
      'WIT': const Duration(hours: 9),
      'London': const Duration(hours: 0),
    };

    final convertedTime = time.toUtc().add(timeZoneOffset[timeZone]!);
    return DateFormat('HH:mm:ss').format(convertedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800.withOpacity(0.95),
        elevation: 0,
        title: Text(
          movie?.title ?? 'Movie Detail',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.red.shade400 : Colors.white,
              ),
              onPressed: movie != null ? _toggleFavorite : null,
              tooltip:
                  isFavorite ? 'Remove from favorites' : 'Add to favorites',
            ),
          ),
        ],
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
          child: _buildBody(),
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
              'Loading movie details...',
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(color: Colors.red.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadMovieDetail,
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

    if (movie == null) {
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
                'Movie Not Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The requested movie could not be found',
                style: TextStyle(color: Colors.blue.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
              children: [
                if (movie!.poster.isNotEmpty)
                  Container(
                    height: 320,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            movie!.poster,
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  movie!.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie!.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (movie!.genre.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: movie!.genre
                              .map((g) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.blue.shade300),
                                    ),
                                    child: Text(
                                      g,
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                                Icons.schedule, 'Duration', movie!.duration),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.calendar_today, 'Release Date',
                                movie!.releaseDate),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                                Icons.person, 'Director', movie!.director),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.language_outlined, 'Language',
                                movie!.language),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (movie!.cast.isNotEmpty) ...[
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cast',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: movie!.cast
                        .map((c) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade300),
                              ),
                              child: Text(
                                c,
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  movie!.description,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currency Conversion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount (IDR)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedCurrencyTo,
                  items: currencies.map((currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrencyTo = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Converted Amount: ${convertCurrency(inputAmount, selectedCurrencyTo)} $selectedCurrencyTo',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select Seat:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: seats.length,
                  itemBuilder: (context, index) {
                    final seat = seats[index];
                    return GestureDetector(
                      onTap: () {
                        if (seat['isAvailable']) {
                          setState(() {
                            seat['isSelected'] = !seat['isSelected'];
                            isSeatSelected = seats.any((s) => s['isSelected']);
                          });
                          _showOverlayNotification(
                              'Seat ${seat['id']} selected successfully!',
                              Colors.blue);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: seat['isSelected']
                              ? Colors.green
                              : seat['isAvailable']
                                  ? Colors.blue.shade100
                                  : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: seat['isSelected']
                                ? Colors.green.shade700
                                : Colors.blue.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            seat['id'],
                            style: TextStyle(
                              color: seat['isAvailable']
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Show Time:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedShowTime,
                      hint: const Text('Choose a time'),
                      items: showTimes.map((time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedShowTime = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedTimeZone,
                      items: ['WIB', 'WITA', 'WIT', 'London']
                          .map((timeZone) => DropdownMenuItem<String>(
                                value: timeZone,
                                child: Text(timeZone),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTimeZone = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Time: ${_convertTimeZone(currentTime, selectedTimeZone)}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Total Harga : Rp ${totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: isSeatSelected && selectedShowTime != null
                      ? () async {
                          setState(() {
                            isTicketPurchased = true;
                            selectedSeats = seats
                                .where((seat) => seat['isSelected'] == true)
                                .map((seat) => seat['id'] as String)
                                .toList();

                            ticketCode =
                                'MOVIE-${DateTime.now().millisecondsSinceEpoch}';
                          });
                          for (var seat in seats) {
                            if (seat['isSelected']) {
                              seat['isAvailable'] = false;
                              seat['isSelected'] = false;
                            }
                          }
                          await TicketHistoryService.saveTicket({
                            "movie": movie!.title,
                            "seat": selectedSeats.join(","),
                            "time": selectedShowTime,
                            "code": ticketCode,
                            "totalPrice": totalPrice,
                            "purchaseDate": DateTime.now().toString(),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Ticket saved to history",
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Buy Ticket'),
                ),
                if (isTicketPurchased) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Ticket Details:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Movie: ${movie?.title ?? 'Unknown'}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Seats: ${selectedSeats.join(', ')}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Show Time: $selectedShowTime',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Total Price: Rp ${totalPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ticket Code:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        ticketCode,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Time:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'WIB: ${_convertTimeZone(currentTime, 'WIB')}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'WITA: ${_convertTimeZone(currentTime, 'WITA')}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'WIT: ${_convertTimeZone(currentTime, 'WIT')}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'London: ${_convertTimeZone(currentTime, 'London')}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Feedback:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your feedback here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      userFeedback = value; // Menyimpan kesan dan pesan
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  "Total Harga : Rp ${totalPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = SentimentService.analyze(userFeedback);

                    setState(() {
                      sentimentResult = result["sentiment"];
                      sentimentScore = result["confidence"];
                    });

                    await FeedbackService.addFeedback(
                      FeedbackModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        movieTitle: movie!.title,
                        feedback: userFeedback,
                        sentiment: result["sentiment"],
                        date: DateTime.now().toString(),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Feedback saved successfully",
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Analyze Feedback',
                  ),
                ),
                if (sentimentResult.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI Sentiment Analysis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Sentiment: $sentimentResult",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Confidence: $sentimentScore%",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 18),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
