import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../viewmodels/notification_view_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Notification center', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      Text('${vm.unreadCount} unread local notifications'),
                    ],
                  ),
                ),
                TextButton(onPressed: vm.markAllRead, child: const Text('Mark all read')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...vm.notifications.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: notification.isRead ? AppColors.background : AppColors.lightGreen,
                  child: Icon(
                    notification.isRead ? Icons.notifications_none_rounded : Icons.notifications_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(
                  '${notification.message}\n${notification.type} • ${DateFormat('dd MMM, HH:mm').format(notification.createdAt)}',
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
