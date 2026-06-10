import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) {
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(initializationSettings);

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'tech_store_channel',
      'Tech Store Notifications',
      channelDescription: 'Notifications for Tech Store app events',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> showCartNotification({
    required String productName,
  }) async {
    await showNotification(
      title: 'Added to Cart',
      body: '$productName was added to your cart.',
    );
  }

  static Future<void> showBookingNotification({
    required String serviceName,
  }) async {
    await showNotification(
      title: 'Booking Created',
      body: 'Your booking for $serviceName has been created.',
    );
  }

  static Future<void> showTaskNotification({
    required String taskTitle,
  }) async {
    await showNotification(
      title: 'Task Reminder',
      body: taskTitle,
    );
  }
}
