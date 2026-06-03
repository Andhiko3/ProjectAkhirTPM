import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: android);

    await notifications.initialize(settings);
  }

  static Future showNotification(
      String title,
      String body,
      ) async {
    const AndroidNotificationDetails android =
        AndroidNotificationDetails(
      'movie_channel',
      'movie_channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: android);

    await notifications.show(
      0,
      title,
      body,
      details,
    );
  }
}