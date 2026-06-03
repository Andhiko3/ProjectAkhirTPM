class SentimentService {
  static final List<String> positiveWords = [
    "bagus",
    "keren",
    "seru",
    "mantap",
    "hebat",
    "luar biasa",
    "menarik",
    "suka",
    "recommended",
    "recommended",
    "awesome",
    "good",
    "best",
    "love",
    "amazing"
  ];

  static final List<String> negativeWords = [
    "jelek",
    "buruk",
    "bosan",
    "membosankan",
    "tidak suka",
    "kecewa",
    "parah",
    "bad",
    "worst",
    "boring",
    "hate",
    "ugly"
  ];

  static Map<String, dynamic> analyze(String text) {
    text = text.toLowerCase();

    int positiveScore = 0;
    int negativeScore = 0;

    for (var word in positiveWords) {
      if (text.contains(word)) {
        positiveScore++;
      }
    }

    for (var word in negativeWords) {
      if (text.contains(word)) {
        negativeScore++;
      }
    }

    String sentiment;
    double confidence;

    if (positiveScore > negativeScore) {
      sentiment = "Positive";
      confidence =
          (positiveScore / (positiveScore + negativeScore + 1)) * 100;
    } else if (negativeScore > positiveScore) {
      sentiment = "Negative";
      confidence =
          (negativeScore / (positiveScore + negativeScore + 1)) * 100;
    } else {
      sentiment = "Neutral";
      confidence = 50;
    }

    return {
      "sentiment": sentiment,
      "confidence": confidence.toStringAsFixed(0),
    };
  }
}