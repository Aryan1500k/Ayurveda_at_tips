import 'package:flutter/material.dart';

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
          TextButton(
            onPressed: () {},
            child: const Text("Clear All", style: TextStyle(color: Color(0xFF009460), fontSize: 12)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("NEW"),

          _buildNotificationItem(
            "Meditation Reminder",
            "It's time for your evening meditation to calm your Vata energy.",
            "Just Now",
            Icons.self_improvement,
            isUnread: true,
          ),
          _buildNotificationItem(
            "Order Shipped",
            "Your Ayurvedic Herbal Tea set has been dispatched and is on its way!",
            "1h ago",
            Icons.local_shipping_outlined,
            isUnread: true,
          ),

          const SizedBox(height: 20),
          _buildSectionHeader("EARLIER"),

          _buildNotificationItem(
            "Quiz Update",
            "Your weekly Dosha analysis report is ready for review.",
            "5h ago",
            Icons.analytics_outlined,
          ),
          _buildNotificationItem(
            "New Blog Post",
            "5 Foods to avoid during the monsoon to prevent Kapha buildup.",
            "Yesterday",
            Icons.menu_book_outlined,
          ),
          _buildNotificationItem(
            "Expert Consultation",
            "Dr. Anjali has confirmed your appointment for tomorrow at 10:00 AM.",
            "1 day ago",
            Icons.event_available,
          ),
          _buildNotificationItem(
            "Health Tip",
            "Drinking warm water in the morning helps detoxify your digestive system.",
            "2 days ago",
            Icons.lightbulb_outline,
          ),
        ],
      ),
    );
  }

  // Helper for Section Titles (NEW / EARLIER)
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

  // Improved Notification Item with "Unread" dot logic
  Widget _buildNotificationItem(String title, String subtitle, String time, IconData icon, {bool isUnread = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF0F9F4) : Colors.white, // Subtle green tint for unread
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isUnread ? const Color(0xFF009460) : const Color(0xFFE8F3EE),
          child: Icon(icon, color: isUnread ? Colors.white : const Color(0xFF009460), size: 20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            if (isUnread)
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
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
              ),
              const SizedBox(height: 5),
              Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}