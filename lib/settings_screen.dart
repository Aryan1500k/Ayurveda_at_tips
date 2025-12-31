import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Account Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _buildSettingTile(Icons.person_outline, "Edit Profile"),
          _buildSettingTile(Icons.lock_outline, "Change Password"),
          const SizedBox(height: 30),
          const Text("Preferences", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          _buildSettingTile(Icons.notifications_active_outlined, "Notification Settings"),
          _buildSettingTile(Icons.language_outlined, "App Language"),
          _buildSettingTile(Icons.dark_mode_outlined, "Dark Mode (Beta)"),
          const SizedBox(height: 30),
          _buildSettingTile(Icons.delete_outline, "Delete Account", isDanger: true),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, {bool isDanger = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isDanger ? Colors.red : Colors.black87),
      title: Text(title, style: TextStyle(color: isDanger ? Colors.red : Colors.black87)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {
        // Implement specific setting navigation here
      },
    );
  }
}