import 'package:flutter/material.dart';

class RoutineTask {
  final String title;
  final String timeOfDay;
  final IconData icon;
  final Color iconColor;

  RoutineTask({
    required this.title,
    required this.timeOfDay,
    required this.icon,
    required this.iconColor,
  });
}

final List<RoutineTask> myRoutine = [
  RoutineTask(title: "Tongue\nScraping", timeOfDay: "MORNING", icon: Icons.cleaning_services, iconColor: Colors.blue),
  RoutineTask(title: "Oil\nPulling", timeOfDay: "MORNING", icon: Icons.opacity, iconColor: Colors.orange),
  RoutineTask(title: "Herb\nIntake", timeOfDay: "NOON", icon: Icons.medical_services_outlined, iconColor: Colors.green),
];