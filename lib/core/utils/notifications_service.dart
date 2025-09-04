import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  static FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );

    await plugin.initialize(settings);
  }

  /// Basic notification
  static Future showBasicNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "basic_channel", // id
          "Basic Notifications", // name
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(id, title, body, details);
  }

  /// Scheduled notification
  static Future showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "scheduled_channel", // id
          "Scheduled Notifications", // name
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
