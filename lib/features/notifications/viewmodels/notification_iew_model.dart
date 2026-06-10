import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'N-1',
      title: 'Welcome to Tech Store',
      message: 'Your green tech dashboard is ready.',
      createdAt: DateTime.now(),
      type: 'System',
      isRead: false,
    ),
  ];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  void push({required String title, required String message, String type = 'Info'}) {
    _notifications.insert(
      0,
      AppNotification(
        id: 'N-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        createdAt: DateTime.now(),
        type: type,
        isRead: false,
      ),
    );
    notifyListeners();
  }

  void markAllRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }
}
