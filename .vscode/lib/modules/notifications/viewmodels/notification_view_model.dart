class NotificationViewModel {
  final List<String> notifications = <String>[
    'Welcome to Tech Store Pro.',
  ];

  void addNotification(String message) {
    notifications.insert(0, message);
  }

  void clearNotifications() {
    notifications.clear();
  }

  int get notificationCount {
    return notifications.length;
  }

  bool get hasNotifications {
    return notifications.isNotEmpty;
  }
}

