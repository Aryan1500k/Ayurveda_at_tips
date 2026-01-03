import 'package:flutter/material.dart';
//import 'app_theme.dart'; // Ensure this path is correct

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uses your global pistachio color
      backgroundColor: const Color(0xFFE8F3EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/logo.png',height: 60,width: 250,fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text("Ayurveda Products"),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Dosha Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF009460).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Vata Dosha", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF009460))),
            ),
            const SizedBox(height: 20),

            const Text("Curated for Your Balance", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Product Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                children: [
                  Expanded(child: _ProductCard(name: "Triphala", desc: "Digestion", price: "29")),
                  SizedBox(width: 15),
                  Expanded(child: _ProductCard(name: "Ashwagandha", desc: "Stress", price: "35")),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // FIXED SECTION: Calling the Classes correctly with 'const'
            Row(
              children: [
                const Expanded(
                  child: _SecondaryCategory(
                      icon: Icons.whatshot,
                      label: "Digestion",
                      color: Color(0xFFFFF3E0),
                      iconColor: Colors.orange
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: _SecondaryCategory(
                      icon: Icons.nightlight_round,
                      label: "Sleep",
                      color: Color(0xFFE3F2FD),
                      iconColor: Colors.blue
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const _SecondaryCategory(
                icon: Icons.face,
                label: "Hair & Skin",
                color: Color(0xFFF3E5F5),
                iconColor: Colors.purple
            ),

            const SizedBox(height: 30),
            _ExpertCTA(),
          ],
        ),
      ),
    );
  }
}

// --- Sub-widgets (The Classes) ---

class _ProductCard extends StatelessWidget {
  final String name, desc, price;
  const _ProductCard({required this.name, required this.desc, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(child: Icon(Icons.image, color: Colors.grey)),
        ),
        const SizedBox(height: 10),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text("\$$price", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF009460))),
      ],
    );
  }
}

class _SecondaryCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, iconColor;

  // This constructor allows the widget to be called with 'const'
  const _SecondaryCategory({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
          ]
      ),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color, child: Icon(icon, color: iconColor)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ExpertCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.people_outline, size: 40, color: Color(0xFF009460)),
          const SizedBox(height: 10),
          const Text("Need Help?", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009460),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Talk to Expert", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}