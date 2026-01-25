import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

// 1. Create a ValueNotifier to track the list
ValueNotifier<List<AppNotification>> notificationNotifier = ValueNotifier([
  AppNotification(
    id: "1",
    title: "Expert Available!",
    body: "Dr. Sharma is now free for a consultation.",
    timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
]);

// 2. Helper function to add notifications from anywhere in the app
void addNewNotification(String title, String body) {
  final newNotif = AppNotification(
    id: DateTime.now().toString(),
    title: title,
    body: body,
    timestamp: DateTime.now(),
  );
  notificationNotifier.value = [...notificationNotifier.value, newNotif];
}