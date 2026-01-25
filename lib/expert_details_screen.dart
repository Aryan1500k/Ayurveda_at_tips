import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/doctor_model.dart';
import 'chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const ExpertDetailsScreen({super.key, required this.doctor});

  @override
  State<ExpertDetailsScreen> createState() => _ExpertDetailsScreenState();
}

class _ExpertDetailsScreenState extends State<ExpertDetailsScreen> {

  // --- BOOKING CALENDAR LOGIC ---
  Future<void> _selectDateTime(BuildContext context) async {
    // 1. Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Disable past dates
      lastDate: DateTime.now().add(const Duration(days: 30)), // Max 30 days ahead
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF009460), // Match your green theme
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // 2. Pick Time
      if (!mounted) return;
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        if (!mounted) return;
        _confirmBookingDialog(context, pickedDate, pickedTime);
      }
    }
  }

  // --- CONFIRMATION & FIREBASE SAVE ---
  void _confirmBookingDialog(BuildContext context, DateTime date, TimeOfDay time) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Appointment"),
        content: Text("Do you want to book an appointment with ${widget.doctor.name} on ${date.day}/${date.month}/${date.year} at ${time.format(context)}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009460)),
            onPressed: () async {
              Navigator.pop(ctx);
              await _saveAppointmentToFirebase(date, time);
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAppointmentToFirebase(DateTime date, TimeOfDay time) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to book an appointment")),
      );
      return;
    }

    try {
      // 1. Convert TimeOfDay to a formatted String (HH:mm)
      String formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

      // 2. Combine Date and Time into a single DateTime object for easier sorting later
      DateTime fullAppointmentDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': user.uid,
        'userEmail': user.email,
        'doctorName': widget.doctor.name,
        'appointmentDateTime': Timestamp.fromDate(fullAppointmentDateTime), // Best for sorting
        'timeString': formattedTime,
        'status': 'Upcoming',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success! Appointment saved."), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Firebase Error: $e"); // Check your Debug Console for the specific error!
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.doctor.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE8F3EE),
                  child: Icon(Icons.person, size: 50, color: Color(0xFF009460)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doctor.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(widget.doctor.specialty, style: const TextStyle(color: Color(0xFF009460), fontSize: 16)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 18),
                          Text(" ${widget.doctor.rating}  •  ${widget.doctor.experience} Exp"),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),

            // Availability Status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.doctor.isAvailable ? const Color(0xFFE8F3EE) : Colors.red[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: widget.doctor.isAvailable ? Colors.green : Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    widget.doctor.isAvailable ? "Available Today" : "Not Available",
                    style: TextStyle(color: widget.doctor.isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text("About Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.doctor.bio, style: const TextStyle(color: Colors.grey, height: 1.5)),

            const SizedBox(height: 30),

            // Communication Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionBtn(
                    Icons.chat_bubble_outline,
                    "Chat",
                    Colors.blue,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(doctor: widget.doctor),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionBtn(
                    Icons.call_outlined,
                    "Call",
                    Colors.green,
                        () async {
                      final Uri launchUri = Uri(scheme: 'tel', path: widget.doctor.phone);
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Could not launch phone dialer")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 4. Booking Button (UPDATED)
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009460),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Book Appointment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}