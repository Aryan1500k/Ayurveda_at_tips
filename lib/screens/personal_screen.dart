import 'package:flutter/material.dart';
import '../models/routine_model.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F3EE), // Pistachio background
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Dinacharya", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF009460))),
                      Text("ANCIENT WISDOM", style: TextStyle(letterSpacing: 1.5, color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                  const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.notifications_none, color: Colors.black)),
                ],
              ),
            ),

            const Spacer(),

            // Result Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Your Pitta energy is balanced. Focus on cooling practices this afternoon.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
              ),
            ),

            const Spacer(),

            // My Dinacharya Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Dinacharya", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text("VIEW ALL", style: TextStyle(color: Color(0xFF009460), fontWeight: FontWeight.bold))),
                ],
              ),
            ),

            // Horizontal Task List
            SizedBox(
              height: 160,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 24),
                scrollDirection: Axis.horizontal,
                itemCount: myRoutine.length,
                itemBuilder: (context, index) => _buildRoutineCard(myRoutine[index]),
              ),
            ),

            const SizedBox(height: 24),

            // Pitta Time Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.orange.shade50, child: const Icon(Icons.wb_sunny_outlined, color: Colors.orange)),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pitta Time (10am - 2pm)", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Digestive fire is strongest now. Have your largest meal.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Check Pulse Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.monitor_heart_outlined),
                label: const Text("Check Pulse"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009460),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(RoutineTask task) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: task.iconColor.withOpacity(0.1),
            child: Icon(task.icon, color: task.iconColor),
          ),
          const Spacer(),
          Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 5),
          Text(task.timeOfDay, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(height: 4, width: 40, color: const Color(0xFF009460)),
        ],
      ),
    );
  }
}