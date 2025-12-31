import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF009460)),
            ),
            const SizedBox(height: 15),
            _buildFAQTile(
              "What is a Dosha?",
              "In Ayurveda, a Dosha is one of three substances that are believed to be present in a person's body and mind.",
            ),
            _buildFAQTile(
              "How accurate is the quiz?",
              "The quiz is based on traditional principles. For a clinical diagnosis, we recommend consulting our 'Expert' section.",
            ),
            _buildFAQTile(
              "How do I update my profile?",
              "You can update your personal details in the 'Profile' section located in the side menu.",
            ),
            const SizedBox(height: 30),
            const Text(
              "Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined, color: Color(0xFF009460)),
              title: const Text("support@ayurvedatips.com"),
              subtitle: const Text("Response within 24 hours"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(answer, style: const TextStyle(color: Colors.black54, height: 1.5)),
        ),
      ],
    );
  }
}