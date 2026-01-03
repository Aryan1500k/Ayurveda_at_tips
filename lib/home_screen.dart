import 'package:flutter/material.dart';
import 'app_theme.dart'; // Correct relative import for same-folder files
import 'timer_screen.dart';

// --- DATA MODEL ---
class WellnessBreak {
  final String title;
  final String description;
  final int durationMinutes;
  final IconData icon;

  WellnessBreak({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.icon,
  });
}

final List<WellnessBreak> wellnessBreaks = [
  WellnessBreak(title: "Breathe Better", description: "Alternate nostril breathing for instant calm", durationMinutes: 2, icon: Icons.air),
  WellnessBreak(title: "Hydration Boost", description: "Drink warm water with lemon", durationMinutes: 1, icon: Icons.water_drop_outlined),
  WellnessBreak(title: "Posture Reset", description: "Simple spine alignment exercise", durationMinutes: 2, icon: Icons.accessibility_new),
  WellnessBreak(title: "Eye Relaxation", description: "Palm and eye circle exercise", durationMinutes: 2, icon: Icons.visibility_outlined),
];

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
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                  width: 250,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.spa, size: 80, color: AppTheme.primaryGreen),
                ),
              ),
              const SizedBox(height: 40),

              // Header Section
              const Text(
                "ANCIENT WISDOM, MODERN WELLNESS",
                style: TextStyle(letterSpacing: 1.8, fontSize: 14, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              const SizedBox(height: 10),
              const Text(
                "Discover Your\nNatural Balance",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1),
              ),
              const SizedBox(height: 20),
              const StatsSection(),
              const SizedBox(height: 30),

              const Text(
                "Understand your unique constitution through a personalized Dosha assessment and unlock a curated wellness journey.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/quiz'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Discover Your Dosha"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const _IconButton(icon: Icons.people_outline, label: "Talk to Expert"),
                ],
              ),
              const SizedBox(height: 40),

              // Feature Cards
              const FeatureCard(
                icon: Icons.auto_awesome_outlined,
                title: "Personalized Assessment",
                desc: "A gentle journey to understand your unique constitution",
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

              const SizedBox(height: 40),

              // --- QUICK WELLNESS BREAKS AT THE BOTTOM ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Quick Wellness Breaks",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B4332)),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "1-2 minute actions you can do anytime, anywhere",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: wellnessBreaks.length,
                  itemBuilder: (context, index) {
                    final item = wellnessBreaks[index];
                    return _buildWellnessCard(context, item);
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWellnessCard(BuildContext context, WellnessBreak item) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE9E3D5),
            child: Icon(item.icon, color: const Color(0xFFC9A227)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Text("${item.durationMinutes} min", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
          const SizedBox(height: 8),
          Text(item.description, style: const TextStyle(fontSize: 13, color: Colors.black54), maxLines: 2),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TimerScreen(breakItem: item))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Do Now"),
          )
        ],
      ),
    );
  }
}

// Sub-widgets for layout
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.pistachioBackground,
            child: Icon(icon, color: AppTheme.primaryGreen),
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

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [Text("10,000+", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B4332))), Text("Assessments", style: TextStyle(fontSize: 12, color: Colors.grey))]),
          VerticalDivider(color: Colors.grey),
          Column(children: [Text("100%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1B4332))), Text("Natural", style: TextStyle(fontSize: 12, color: Colors.grey))]),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [Icon(icon, size: 20, color: AppTheme.primaryGreen), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))]),
    );
  }
}
