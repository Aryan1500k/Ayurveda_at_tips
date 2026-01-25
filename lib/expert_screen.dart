import 'package:flutter/material.dart';

class ExpertScreen extends StatefulWidget {
  const ExpertScreen({super.key});

  @override
  State<ExpertScreen> createState() => _ExpertScreenState();
}

class _ExpertScreenState extends State<ExpertScreen> {
  // Function to show the Bottom Sheet for Chat or Call
  void _showFormSheet(bool isChat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(isChat ? Icons.chat_bubble_outline : Icons.phone_outlined, color: const Color(0xFF8B6B23)),
                  const SizedBox(width: 10),
                  Text(isChat ? "Start a chat" : "Request a Call", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 25),
              _buildTextField("Name"),
              _buildTextField("Phone Number", keyboardType: TextInputType.phone),
              _buildTextField("Email (optional)", keyboardType: TextInputType.emailAddress),
              _buildTextField("Briefly describe your concern", maxLines: 3),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Back", style: TextStyle(color: Colors.black)))),
                  const SizedBox(width: 15),
                  Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB4906C), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Submit", style: TextStyle(color: Colors.white)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text("Expert", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Connect with an Expert", style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 22)),
            const SizedBox(height: 30),

            // --- TOP CARDS (Chat & Call) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildActionCard("Chat with\nExpert", "Get quick answers via messaging", Icons.chat_bubble_outline, const Color(0xFFE8F5E9), Colors.green, () => _showFormSheet(true)),
                  const SizedBox(width: 15),
                  _buildActionCard("Book a\nCall", "Schedule a consultation call", Icons.phone_outlined, const Color(0xFFFFF3E0), Colors.orange, () => _showFormSheet(false)),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("—  Get personalized guidance from  —\ncertified Ayurvedic practitioners.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TrustIcon(Icons.verified_outlined, "Certified"),
                SizedBox(width: 20),
                _TrustIcon(Icons.history_toggle_off, "Quick Response"),
                SizedBox(width: 20),
                _TrustIcon(Icons.shield_outlined, "Confidential"),
              ],
            ),

            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerLeft, child: Text("Our Practitioners", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            ),

            // --- PRACTITIONERS LIST ---
            _buildPractitionerCard("Dr. Anjali Sharma", "Senior Ayurvedic Physician", "15+ Years", "Digestive Health & Detox", "A", true),
            _buildPractitionerCard("Vaidya Rajesh Patel", "Traditional Ayurveda Practitioner", "20+ Years", "Stress management & Sleep", "V", true),
            _buildPractitionerCard("Dr. Priya Menon", "Ayurvedic Wellness Coach", "10+ Years", "Women's Health & Hormones", "P", false),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String sub, IconData icon, Color bg, Color iconColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: iconColor)),
              const SizedBox(height: 15),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPractitionerCard(String name, String role, String exp, String spec, String initial, bool isAvailable) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 30, backgroundColor: const Color(0xFFFBE9E7), child: Text(initial, style: const TextStyle(color: Color(0xFF8B6B23), fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(role, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(10)),
                child: Text(isAvailable ? "Available" : "Busy", style: TextStyle(color: isAvailable ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _Tag(exp),
              const SizedBox(width: 10),
              _Tag(spec),
            ],
          ),
          const SizedBox(height: 15),
          const Row(
            children: [
              Icon(Icons.check, size: 16, color: Color(0xFF8B6B23)), SizedBox(width: 5), Text("BAMS", style: TextStyle(fontSize: 12)),
              SizedBox(width: 20),
              Icon(Icons.check, size: 16, color: Color(0xFF8B6B23)), SizedBox(width: 5), Text("Expert Practitioner", style: TextStyle(fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9F4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFF8F9F4), borderRadius: BorderRadius.circular(10)), child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)));
  }
}

class _TrustIcon extends StatelessWidget {
  final IconData icon; final String label;
  const _TrustIcon(this.icon, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(children: [Icon(icon, size: 20, color: Colors.grey), const SizedBox(height: 5), Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey))]);
  }
}