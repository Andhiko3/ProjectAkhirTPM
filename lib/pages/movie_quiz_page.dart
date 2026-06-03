import 'dart:async';
import 'package:flutter/material.dart';

class MovieQuizPage extends StatefulWidget {
  final String genre;

  const MovieQuizPage({
    super.key,
    required this.genre,
  });

  @override
  State<MovieQuizPage> createState() => _MovieQuizPageState();
}

class _MovieQuizPageState extends State<MovieQuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int lives = 3;

  int timeLeft = 15;
  Timer? timer;

  late List<Map<String, dynamic>> questions;

  final horrorQuestions = [
    {
      "question": "Siapa sutradara film KKN di Desa Penari?",
      "options": ["Awi Suryadi", "Joko Anwar", "Hanung Bramantyo", "Riri Riza"],
      "answer": 0
    },
    {
      "question": "Film Pengabdi Setan dirilis ulang pada tahun?",
      "options": ["2015", "2016", "2017", "2018"],
      "answer": 2
    },
    {
      "question": "Pemeran Rini dalam Pengabdi Setan adalah?",
      "options": [
        "Tara Basro",
        "Prilly Latuconsina",
        "Adhisty Zara",
        "Chelsea Islan"
      ],
      "answer": 0
    },
    {
      "question": "Film Insidious berasal dari negara?",
      "options": ["Indonesia", "Thailand", "Amerika Serikat", "Korea Selatan"],
      "answer": 2
    },
    {
      "question": "Siapa sutradara film Pengabdi Setan?",
      "options": [
        "Awi Suryadi",
        "Joko Anwar",
        "Timo Tjahjanto",
        "Ernest Prakasa"
      ],
      "answer": 1
    },
    {
      "question": "Film The Nun termasuk dalam universe?",
      "options": ["Marvel", "DC", "Conjuring", "Transformers"],
      "answer": 2
    },
    {
      "question": "KKN di Desa Penari pertama kali tayang tahun?",
      "options": ["2020", "2021", "2022", "2023"],
      "answer": 2
    },
    {
      "question": "Film horror karya Ari Aster adalah?",
      "options": ["Hereditary", "Avatar", "Titanic", "Joker"],
      "answer": 0
    },
    {
      "question": "Pemeran utama film Talk To Me adalah?",
      "options": ["Sophie Wilde", "Emma Watson", "Zendaya", "Jenna Ortega"],
      "answer": 0
    },
    {
      "question": "Film IT menceritakan teror badut bernama?",
      "options": ["Chucky", "Annabelle", "Pennywise", "Valak"],
      "answer": 2
    }
  ];

  final comedyQuestions = [
    {
      "question": "Siapa pemeran utama film Agak Laen?",
      "options": ["Bene Dion", "Indra Jegel", "Boris Bokir", "Semua benar"],
      "answer": 3
    },
    {
      "question": "Film Agak Laen rilis tahun?",
      "options": ["2022", "2023", "2024", "2025"],
      "answer": 2
    },
    {
      "question": "Siapa sutradara film Cek Toko Sebelah?",
      "options": ["Ernest Prakasa", "Joko Anwar", "Awi Suryadi", "Hanung"],
      "answer": 0
    },
    {
      "question": "Film Warkop DKI Reborn bergenre?",
      "options": ["Action", "Drama", "Comedy", "Horor"],
      "answer": 2
    },
    {
      "question": "Pemeran Dono di Warkop DKI Reborn?",
      "options": ["Abimana", "Vino G Bastian", "Tora Sudiro", "Indro"],
      "answer": 0
    },
    {
      "question": "Film Ngeri-Ngeri Sedap berasal dari negara?",
      "options": ["Malaysia", "Indonesia", "Thailand", "Singapura"],
      "answer": 1
    },
    {
      "question": "Film Comic 8 disutradarai oleh?",
      "options": ["Anggy Umbara", "Ernest", "Hanung", "Riri Riza"],
      "answer": 0
    },
    {
      "question": "Mr. Bean diperankan oleh?",
      "options": ["Tom Cruise", "Rowan Atkinson", "Jim Carrey", "Adam Sandler"],
      "answer": 1
    },
    {
      "question": "Film Home Alone dibintangi oleh?",
      "options": ["Macaulay Culkin", "Leonardo", "Tom Holland", "Chris Evans"],
      "answer": 0
    },
    {
      "question": "Film Agak Laen berlatar tempat?",
      "options": ["Mall", "Sekolah", "Rumah Hantu", "Pantai"],
      "answer": 2
    }
  ];

  final actionQuestions = [
    {
      "question": "Siapa pemeran John Wick?",
      "options": ["Keanu Reeves", "Tom Cruise", "Vin Diesel", "Jason Statham"],
      "answer": 0
    },
    {
      "question": "Film The Raid berasal dari?",
      "options": ["Thailand", "Indonesia", "Korea", "Jepang"],
      "answer": 1
    },
    {
      "question": "Pemeran utama The Raid?",
      "options": ["Iko Uwais", "Joe Taslim", "Arifin Putra", "Yayan Ruhian"],
      "answer": 0
    },
    {
      "question": "Film Fast & Furious terkenal dengan tema?",
      "options": ["Balapan", "Horor", "Komedi", "Drama"],
      "answer": 0
    },
    {
      "question": "Mission Impossible diperankan oleh?",
      "options": ["Tom Cruise", "Chris Hemsworth", "Keanu Reeves", "Brad Pitt"],
      "answer": 0
    },
    {
      "question": "Siapa villain utama di Avengers Endgame?",
      "options": ["Ultron", "Loki", "Thanos", "Red Skull"],
      "answer": 2
    },
    {
      "question": "Film Mad Max berlatar?",
      "options": [
        "Masa lalu",
        "Dunia pasca-apokaliptik",
        "Luar angkasa",
        "Sekolah"
      ],
      "answer": 1
    },
    {
      "question": "The Expendables berisi kumpulan?",
      "options": ["Penyanyi", "Aktor laga", "Politisi", "Atlet"],
      "answer": 1
    },
    {
      "question": "Film Top Gun Maverick rilis tahun?",
      "options": ["2020", "2021", "2022", "2023"],
      "answer": 2
    },
    {
      "question": "Pemeran Maverick adalah?",
      "options": ["Tom Cruise", "Keanu Reeves", "Ryan Gosling", "Will Smith"],
      "answer": 0
    }
  ];

  final dramaQuestions = [
    {
      "question": "Film Miracle in Cell No.7 berasal dari remake film?",
      "options": ["Korea Selatan", "Thailand", "Jepang", "China"],
      "answer": 0
    },
    {
      "question": "Titanic dirilis tahun?",
      "options": ["1995", "1996", "1997", "1998"],
      "answer": 2
    },
    {
      "question": "Pemeran Jack di Titanic?",
      "options": ["Tom Cruise", "Leonardo DiCaprio", "Brad Pitt", "Matt Damon"],
      "answer": 1
    },
    {
      "question": "Film Forrest Gump diperankan oleh?",
      "options": ["Tom Hanks", "Johnny Depp", "Will Smith", "Robert Downey Jr"],
      "answer": 0
    },
    {
      "question": "Film Habibie & Ainun menceritakan kisah?",
      "options": ["Presiden Soeharto", "BJ Habibie", "Jokowi", "Soekarno"],
      "answer": 1
    },
    {
      "question": "Aktor utama The Pursuit of Happyness?",
      "options": ["Will Smith", "Tom Hanks", "Keanu Reeves", "Chris Evans"],
      "answer": 0
    },
    {
      "question": "Film Dilan berlatar kota?",
      "options": ["Bandung", "Jakarta", "Surabaya", "Yogyakarta"],
      "answer": 0
    },
    {
      "question": "Pemeran Milea adalah?",
      "options": [
        "Prilly",
        "Ariel Tatum",
        "Vanesha Prescilla",
        "Chelsea Islan"
      ],
      "answer": 2
    },
    {
      "question": "Film Nanti Kita Cerita Tentang Hari Ini disingkat?",
      "options": ["NKCTHI", "NKCTHIA", "NKCTHI", "NKCTHIA"],
      "answer": 0
    },
    {
      "question": "Siapa sutradara Laskar Pelangi?",
      "options": ["Riri Riza", "Joko Anwar", "Ernest", "Hanung"],
      "answer": 0
    }
  ];

  final sciFiQuestions = [
    {
      "question": "Siapa sutradara film Interstellar?",
      "options": [
        "Christopher Nolan",
        "James Cameron",
        "Steven Spielberg",
        "Ridley Scott"
      ],
      "answer": 0
    },
    {
      "question": "Film Avatar pertama dirilis pada tahun?",
      "options": ["2007", "2008", "2009", "2010"],
      "answer": 2
    },
    {
      "question": "Siapa pemeran utama film Avatar?",
      "options": [
        "Sam Worthington",
        "Tom Holland",
        "Chris Pratt",
        "Ryan Reynolds"
      ],
      "answer": 0
    },
    {
      "question": "Planet tempat tinggal bangsa Na'vi bernama?",
      "options": ["Titan", "Pandora", "Arrakis", "Vormir"],
      "answer": 1
    },
    {
      "question": "Film Dune (2021) diperankan oleh?",
      "options": [
        "Timothée Chalamet",
        "Tom Cruise",
        "Chris Evans",
        "Keanu Reeves"
      ],
      "answer": 0
    },
    {
      "question": "Siapa karakter utama dalam film Matrix?",
      "options": ["Neo", "Thor", "Luke Skywalker", "Paul Atreides"],
      "answer": 0
    },
    {
      "question": "Pemeran Neo dalam Matrix adalah?",
      "options": ["Keanu Reeves", "Tom Hanks", "Brad Pitt", "Matt Damon"],
      "answer": 0
    },
    {
      "question": "Lightsaber identik dengan film?",
      "options": ["Star Wars", "Star Trek", "Avatar", "Dune"],
      "answer": 0
    },
    {
      "question": "Film WALL-E diproduksi oleh studio?",
      "options": ["Pixar", "DreamWorks", "Marvel", "DC"],
      "answer": 0
    },
    {
      "question": "Film Interstellar dirilis pada tahun?",
      "options": ["2012", "2013", "2014", "2015"],
      "answer": 2
    }
  ];

  @override
  void initState() {
    super.initState();

    switch (widget.genre) {
      case "Horror":
        questions = horrorQuestions;
        break;

      case "Comedy":
        questions = comedyQuestions;
        break;

      case "Action":
        questions = actionQuestions;
        break;

      case "Drama":
        questions = dramaQuestions;
        break;

      default:
        questions = sciFiQuestions;
    }

    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    timeLeft = 15;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } else {
          answer("");
        }
      },
    );
  }

  void answer(String selected) {
    timer?.cancel();

    if (selected == questions[currentQuestion]["correct"]) {
      score += 20;
    } else {
      lives--;
    }

    if (lives <= 0) {
      showResult("Game Over");
      return;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });

      startTimer();
    } else {
      showResult("Quiz Finished");
    }
  }

  void showResult(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(
          "Score : $score",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.genre} Quiz",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
            ),
            const SizedBox(height: 15),
            Text(
              "❤️" * lives,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Score : $score",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "⏱️ $timeLeft",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              q["question"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...(q["options"] as List<dynamic>).map(
              (ans) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    answer(ans);
                  },
                  child: Text(ans),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
