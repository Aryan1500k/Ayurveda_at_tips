import 'package:flutter/material.dart';
import '../app_theme.dart'; // Ensure correct path

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Logo Placeholder
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/logo.png', height: 80,width: 250,
                ),
              ),
              const SizedBox(height: 40),

              // Header Text
              const Text(
                "ANCIENT WISDOM, MODERN WELLNESS",
                style: TextStyle(letterSpacing: 1.8, fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 10),
              const Text(
                "Discover Your\nNatural Balance",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1),
              ),
              const SizedBox(height: 20),
              const Text(
                "Understand your unique constitution through a personalized Dosha assessment and unlock a curated wellness journey.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 17),
              ),
              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Discover Your Dosha"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const _IconButton(icon: Icons.people_outline, label: "Talk to Expert"),
                ],
              ),
              const SizedBox(height: 30),

              // Feature Cards
              const FeatureCard(
                icon: Icons.auto_awesome_outlined,
                title: "Personalized Assessment",
                desc: "A gentle 10-question journey to understand your unique constitution",
              ),
              const FeatureCard(
                icon: Icons.eco_outlined,
                title: "Curated Recommendations",
                desc: "Products and practices tailored specifically to your Dosha type",
              ),
              const FeatureCard(
                icon: Icons.person_search_outlined,
                title: "Expert Guidance",
                desc: "Connect with certified Ayurvedic practitioners for personalized advice",
              ),

              // Stats Section
              const SizedBox(height: 20),
              const StatsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// Sub-widget for Feature Cards
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const FeatureCard({required this.icon, required this.title, required this.desc, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.pistachioBackground,
            child: Icon(icon, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

// Sub-widget for Stats
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [Text("10,000+", style: TextStyle(fontWeight: FontWeight.bold)), Text("Assessments")]),
          Column(children: [Text("100%", style: TextStyle(fontWeight: FontWeight.bold)), Text("Natural")]),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(children: [Icon(icon, size: 20), const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 12))]),
    );
  }
}