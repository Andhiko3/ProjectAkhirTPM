import 'package:flutter/material.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class FeedbackManagementPage extends StatefulWidget {
  const FeedbackManagementPage({
    super.key,
  });

  @override
  State<FeedbackManagementPage>
      createState() =>
          _FeedbackManagementPageState();
}

class _FeedbackManagementPageState
    extends State<
        FeedbackManagementPage> {
  List<FeedbackModel> feedbacks = [];

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  Future<void> loadFeedbacks() async {
    final data =
        await FeedbackService.getFeedbacks();

    setState(() {
      feedbacks = data;
    });
  }

  Future<void> deleteFeedback(
      String id) async {
    await FeedbackService.deleteFeedback(
      id,
    );

    loadFeedbacks();
  }

  void editFeedback(
      FeedbackModel feedback) {
    final controller =
        TextEditingController(
      text: feedback.feedback,
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:
              const Text("Edit Feedback"),
          content: TextField(
            controller: controller,
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FeedbackService
                    .updateFeedback(
                  FeedbackModel(
                    id: feedback.id,
                    movieTitle:
                        feedback.movieTitle,
                    feedback:
                        controller.text,
                    sentiment:
                        feedback.sentiment,
                    date:
                        feedback.date,
                  ),
                );

                Navigator.pop(context);

                loadFeedbacks();
              },
              child:
                  const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback Management",
        ),
      ),
      body: ListView.builder(
        itemCount:
            feedbacks.length,
        itemBuilder:
            (context, index) {
          final item =
              feedbacks[index];

          return Card(
            margin:
                const EdgeInsets.all(
                    10),
            child: ListTile(
              title:
                  Text(item.movieTitle),
              subtitle: Text(
                item.feedback,
              ),
              trailing: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                    ),
                    onPressed: () {
                      editFeedback(
                        item,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color:
                          Colors.red,
                    ),
                    onPressed: () {
                      deleteFeedback(
                        item.id,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}