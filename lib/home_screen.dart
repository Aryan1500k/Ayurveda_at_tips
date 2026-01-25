import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onDiscoverDosha; // Navigates to Quiz Tab
  final VoidCallback onTalkToExpert;  // Navigates to Expert Tab
  final VoidCallback onExploreProducts; // Navigates to Products Tab

  const HomeScreen({
    super.key,
    required this.onDiscoverDosha,
    required this.onTalkToExpert,
    required this.onExploreProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4), // Light off-white background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // --- HEADER SECTION ---
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "AYURVEDA",
                      style: TextStyle(
                        fontFamily: 'Trajan Pro', // Using your custom font
                        fontSize: 28,
                        letterSpacing: 4,
                        color: Color(0xFF5A6344),
                      ),
                    ),
                    const Text("AT TIPS", style: TextStyle(letterSpacing: 2, fontSize: 12)),
                    const SizedBox(height: 10),
                    const Text("— Ancient Wisdom, Modern Wellness —",
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 30),
                    // Logo Placeholder (Replace with your logo asset)
                    Image.asset('assets/logo.png', height: 80, errorBuilder: (c, e, s) =>
                    const Icon(Icons.spa_outlined, size: 80, color: Color(0xFFB8860B))),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFAF2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text("Discover Your Natural Balance",
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                          const SizedBox(height: 8),
                          const Text(
                            "Understand your unique constitution through a personalized",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const Text(
                            "Dosha assessment",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onDiscoverDosha,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B6B23),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Discover your Dosha >", style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onTalkToExpert,
                            icon: const Icon(Icons.people_outline, size: 16),
                            label: const Text("Talk to an expert", style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
            // --- THE THREE DOSHAS SECTION ---
            const Center(
              child: Text("The Three Doshas",
                  style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 22, color: Color(0xFF2C2C2C))),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: Text(
                "Ayurveda recognizes three fundamental energies that govern our physical and mental processes",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),

            _buildDoshaCard("Vata", "Air & Space", "Creative, quick-minded, adaptable", const Color(0xFF9CA68E)),
            _buildDoshaCard("Pitta", "Fire & Water", "Focused, Ambitious & Determined", const Color(0xFFB4906C)),
            _buildDoshaCard("Kapha", "Earth & Water", "Calm, Nurturing & Steady", const Color(0xFF7E8B6D)),

            const SizedBox(height: 40),
            // --- HEALING THROUGH NATURE ---
            const Center(
              child: Text("Healing Through Nature",
                  style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 22)),
            ),
            const Center(child: Text("— Nature's Pharmacy —", style: TextStyle(color: Colors.grey, fontSize: 12))),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Ayurveda harnesses the power of time-tested herbs and natural remedies to bring your body into balance. From turmeric to ashwagandha, discover nature's most potent healing ingredients.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: onExploreProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B6B23),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Explore Products", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 40),
            // --- FEATURES GRID ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  _buildFeatureCard(Icons.wb_sunny_outlined, "Personalized Assessment", "A gentle 30-question journey to understand your unique constitution"),
                  _buildFeatureCard(Icons.eco_outlined, "Curated Recommendations", "Products and practices tailored specifically to your Dosha type"),
                  _buildFeatureCard(Icons.people_outline, "Expert Guidance", "Connect with certified Ayurvedic practitioners for personalized advice"),
                ],
              ),
            ),

            const SizedBox(height: 40),
            // --- TRUSTED BY SECTION ---
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat("10,000+", "Assessments Completed"),
                  Container(height: 30, width: 1, color: Colors.grey[300]),
                  _buildStat("100%", "Neutral"),
                ],
              ),
            ),
            const SizedBox(height: 100), // Bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaCard(String title, String subtitle, String desc, Color tagColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFAF2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.circle_outlined, color: tagColor)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(10)),
                  child: Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(height: 8),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String desc) {
    return Container(
      width: 170, // Fixed width for grid look
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 28),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}