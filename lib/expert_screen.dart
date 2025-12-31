import 'package:flutter/material.dart';

class ExpertScreen extends StatelessWidget {
  const ExpertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background is naturally light pistachio from your main theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // FIXED: Using local asset instead of fake URL
        title: Image.asset('assets/logo.png', height: 60,width: 250, errorBuilder: (context, error, stackTrace) {
          return const Text("AYURVEDA", style: TextStyle(color: Colors.black, letterSpacing: 2));
        }),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Connect with an Expert",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Get personalized guidance from certified Ayurvedic practitioners with decades of experience.",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Benefit Icons Row
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BenefitIcon(icon: Icons.verified_outlined, label: "Certified\nPractitioners"),
                _BenefitIcon(icon: Icons.access_time, label: "Quick\nResponse"),
                _BenefitIcon(icon: Icons.shield_outlined, label: "Confidential"),
              ],
            ),
            const SizedBox(height: 30),

            // Chat and Call Cards
            const _ActionCard(
              icon: Icons.chat_bubble_outline,
              title: "Chat with Expert",
              subtitle: "Get quick answers via messaging",
              color: Color(0xFFE8F3EE),
              iconColor: Color(0xFF009460),
            ),
            const SizedBox(height: 12),
            const _ActionCard(
              icon: Icons.phone_outlined,
              title: "Book a Call",
              subtitle: "Schedule a conversation call",
              color: Color(0xFFF5F0E6),
              iconColor: Color(0xFFC4A484),
            ),
            const SizedBox(height: 30),

            const Text("Our Practitioners",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Practitioner Cards (Matching your Image_390485.png)
            const _PractitionerCard(
              name: "Dr. Anjali Sharma",
              role: "Senior Ayurvedic Physician",
              experience: "15+ years",
              specialty: "Digestive Health & Detox",
              status: "Available",
              qualifications: ["BAMS", "MD Ayurveda"],
            ),
            const _PractitionerCard(
              name: "Vaidya Rajesh Patel",
              role: "Traditional Ayurveda Practitioner",
              experience: "20+ years",
              specialty: "Stress Management & Sleep",
              status: "Available",
              qualifications: ["BAMS", "Panchakarma specialist"],
            ),
          ],
        ),
      ),
    );
  }
}

// --- SUB-WIDGETS (Required for the screen to work) ---

class _BenefitIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BenefitIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFE8F3EE),
          child: Icon(icon, color: const Color(0xFF009460), size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color, iconColor;
  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}

class _PractitionerCard extends StatelessWidget {
  final String name, role, experience, specialty, status;
  final List<String> qualifications;

  const _PractitionerCard({
    required this.name, required this.role, required this.experience,
    required this.specialty, required this.status, required this.qualifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE8F3EE),
                  child: Text("D", style: TextStyle(color: Color(0xFF009460), fontSize: 24))
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        _StatusChip(status: status),
                      ],
                    ),
                    Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _Tag(text: experience),
              const SizedBox(width: 8),
              Expanded(child: _Tag(text: specialty)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: qualifications.map((q) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(children: [
                const Icon(Icons.check, size: 14, color: Color(0xFF009460)),
                const SizedBox(width: 4),
                Text(q, style: const TextStyle(fontSize: 12, color: Color(0xFF009460))),
              ]),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = status == "Available";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xFFE8F3EE) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAvailable ? Colors.green : Colors.grey)),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}