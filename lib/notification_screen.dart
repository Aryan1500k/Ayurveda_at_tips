import 'package:flutter/material.dart';
import 'models/app_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ValueListenableBuilder<List<AppNotification>>(
            valueListenable: notificationNotifier,
            builder: (context, notifications, child) {
              if (notifications.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () {
                  // Logic to mark all as read or clear could go here
                },
                child: const Text("Clear All",
                    style: TextStyle(color: Color(0xFF009460), fontSize: 12)),
              );
            },
          ),
        ],
      ),
      // --- REAL-TIME REACTIVE BODY ---
      body: ValueListenableBuilder<List<AppNotification>>(
        valueListenable: notificationNotifier,
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet"));
          }

          // Dynamically split notifications from the notifier
          final newNotifications = notifications.where((n) => !n.isRead).toList().reversed.toList();
          final earlierNotifications = notifications.where((n) => n.isRead).toList().reversed.toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (newNotifications.isNotEmpty) ...[
                _buildSectionHeader("NEW"),
                ...newNotifications.map((n) => _buildNotificationItem(context, n)),
              ],
              if (earlierNotifications.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildSectionHeader("EARLIER"),
                ...earlierNotifications.map((n) => _buildNotificationItem(context, n)),
              ],
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, AppNotification notification) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? (isDark ? Colors.grey[900] : Colors.white)
            : (isDark ? const Color(0xFF1B4332) : const Color(0xFFF0F9F4)),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: !notification.isRead ? const Color(0xFF009460) : const Color(0xFFE8F3EE),
          child: Icon(
              Icons.notifications_active_outlined,
              color: !notification.isRead ? Colors.white : const Color(0xFF009460),
              size: 20
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: !notification.isRead ? FontWeight.bold : FontWeight.w600,
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    height: 1.4
                ),
              ),
              const SizedBox(height: 5),
              Text(
                  "${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey)
              ),
            ],
          ),
        ),
        onTap: () {
          // Optional: Mark as read when tapped
          if (!notification.isRead) {
            notification.isRead = true;
            // Trigger a refresh of the notifier
            notificationNotifier.value = List.from(notificationNotifier.value);
          }
        },
      ),
    );
  }
}