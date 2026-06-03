class FeedbackModel {

final String id;
final String movieTitle;
final String feedback;
final String sentiment;
final String date;

FeedbackModel({
required this.id,
required this.movieTitle,
required this.feedback,
required this.sentiment,
required this.date,
});

Map<String,dynamic> toJson(){
return{
"id":id,
"movieTitle":movieTitle,
"feedback":feedback,
"sentiment":sentiment,
"date":date,
};
}

factory FeedbackModel.fromJson(
Map<String,dynamic> json){
return FeedbackModel(
id: json["id"],
movieTitle: json["movieTitle"],
feedback: json["feedback"],
sentiment: json["sentiment"],
date: json["date"],
);
}
}
