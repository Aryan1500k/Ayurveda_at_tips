import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  // 1. Updated constructor to receive the global state and toggle function
  final Function(bool) onThemeChanged;
  final bool isDark;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDark
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // We keep selectedLanguage here, but isDarkMode is now managed by the parent
  String selectedLanguage = "English";

  // --- LANGUAGE PICKER LOGIC ---
  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        // Use widget.isDark to decide color
        color: widget.isDark ? Colors.grey[900] : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Language",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : Colors.black,
                )),
            const Divider(),
            _languageTile("English"),
            _languageTile("Hindi"),
            _languageTile("Marathi"),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(String lang) {
    return ListTile(
      title: Text(lang, style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black87)),
      trailing: selectedLanguage == lang
          ? const Icon(Icons.check, color: Color(0xFF009460))
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = lang;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Language changed to $lang")),
        );
      },
    );
  }

  // --- PASSWORD RESET LOGIC ---
  void _showChangePasswordDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? Colors.grey[900] : Colors.white,
        title: Text("Reset Password", style: TextStyle(color: widget.isDark ? Colors.white : Colors.black)),
        content: Text("We will send a password reset link to your email.",
            style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009460)),
            onPressed: () async {
              if (user?.email != null) {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email Sent! Check your inbox.")));
              }
            },
            child: const Text("Send Link", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Note: We don't need to manually set backgroundColor here because
    // MaterialApp's darkTheme will handle the Scaffold color automatically!
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const _SettingsHeader(title: "Account Settings"),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showChangePasswordDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text(selectedLanguage, style: const TextStyle(color: Colors.grey)),
            onTap: () => _showLanguagePicker(context),
          ),

          const _SettingsHeader(title: "App Settings"),

          // --- THE GLOBAL THEME SWITCH ---
          SwitchListTile(
            secondary: Icon(
              widget.isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
              color: widget.isDark ? Colors.amber : Colors.grey,
            ),
            title: const Text("Dark Mode"),
            value: widget.isDark, // Connected to main.dart
            activeColor: const Color(0xFF009460),
            onChanged: (val) {
              // This triggers the _toggleTheme function in main.dart
              widget.onThemeChanged(val);
            },
          ),

          const _SettingsHeader(title: "Support"),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help Center"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;
  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
    );
  }
}