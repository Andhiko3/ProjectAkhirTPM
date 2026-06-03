import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<FeedbackModel> feedbacks = [];

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  Future<void> loadFeedbacks() async {
    final data = await FeedbackService.getFeedbacks();

    setState(() {
      feedbacks = data;
    });
  }

  Future<void> deleteFeedback(String id) async {
    await FeedbackService.deleteFeedback(id);

    loadFeedbacks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Feedback deleted",
        ),
      ),
    );
  }

  void showEditDialog(FeedbackModel feedback) {
    final controller = TextEditingController(
      text: feedback.feedback,
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Feedback"),
          content: TextField(
            controller: controller,
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FeedbackService.updateFeedback(
                  FeedbackModel(
                    id: feedback.id,
                    movieTitle: feedback.movieTitle,
                    feedback: controller.text,
                    sentiment: feedback.sentiment,
                    date: feedback.date,
                  ),
                );

                Navigator.pop(context);

                loadFeedbacks();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback History"),
      ),
      body: feedbacks.isEmpty
          ? const Center(
              child: Text("No Feedback"),
            )
          : ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final item = feedbacks[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item.movieTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.feedback),
                        Text(
                          "Sentiment: ${item.sentiment}",
                        ),
                        Text(item.date),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.feedback,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
