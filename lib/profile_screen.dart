import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data?.data() as Map<String, dynamic>?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE8F3EE),
                  child: Icon(Icons.person, size: 50, color: Color(0xFF009460)),
                ),
                const SizedBox(height: 15),
                Text(
                  userData?['name'] ?? "Ayurveda User",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(user?.email ?? "No Email", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),

                // Dosha Result Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF009460),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Dosha Type", style: TextStyle(color: Colors.white70)),
                          Text("Vata-Pitta", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.spa, color: Colors.white, size: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                _buildProfileItem(Icons.phone, "Phone", userData?['phone'] ?? "Not set"),
                _buildProfileItem(Icons.location_on, "Address", userData?['address'] ?? "Not set"),
                _buildProfileItem(Icons.calendar_today, "Member Since", "Jan 2024"),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showEditProfileDialog(context, userData),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009460),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF009460)),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
  // Add this method inside the ProfileScreen class
  void _showEditProfileDialog(BuildContext context, Map<String, dynamic>? userData) {
    final nameController = TextEditingController(text: userData?['name']);
    final phoneController = TextEditingController(text: userData?['phone']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                try {
                  // Use .set with merge: true to avoid "NOT_FOUND" errors
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                    'name': nameController.text.trim(),
                    'phone': phoneController.text.trim(),
                    'email': user.email, // Good practice to keep email synced
                  }, SetOptions(merge: true));

                  if (context.mounted) Navigator.pop(ctx);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile Updated!"), backgroundColor: Colors.green),
                  );
                } catch (e) {
                  print("Error saving profile: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}