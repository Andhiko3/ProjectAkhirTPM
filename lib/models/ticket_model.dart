class TicketModel {
  final String movie;
  final String seat;
  final String time;
  final String code;
  final double totalPrice;
  final String purchaseDate;

  TicketModel({
    required this.movie,
    required this.seat,
    required this.time,
    required this.code,
    required this.totalPrice,
    required this.purchaseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "movie": movie,
      "seat": seat,
      "time": time,
      "code": code,
      "totalPrice": totalPrice,
      "purchaseDate": purchaseDate,
    };
  }

  factory TicketModel.fromJson(
      Map<String, dynamic> json) {
    return TicketModel(
      movie: json["movie"],
      seat: json["seat"],
      time: json["time"],
      code: json["code"],
      totalPrice:
          (json["totalPrice"] as num).toDouble(),
      purchaseDate: json["purchaseDate"],
    );
  }
}