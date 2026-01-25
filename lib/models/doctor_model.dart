import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final String experience;
  final String image;
  final bool isAvailable;
  final String phone;
  final String bio;
  final double rating;

  Doctor({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.image,
    required this.isAvailable,
    required this.phone,
    required this.bio,
    required this.rating,
  });
}

// Sample Data
final List<Doctor> ayurvedaExperts = [
  Doctor(
    name: "Dr. Ananya Sharma",
    specialty: "Nadi Pariksha Expert",
    experience: "12+ Years",
    image: "assets/doctor1.png", // Ensure you have images in assets
    isAvailable: true,
    phone: "+91 9876543210",
    rating: 4.9,
    bio: "Specialist in identifying root causes through pulse diagnosis and herbal detoxification.",
  ),
  Doctor(
    name: "Dr. Rohan Varma",
    specialty: "Panchakarma Specialist",
    experience: "8 Years",
    image: "assets/doctor2.png",
    isAvailable: false,
    phone: "+91 8888877777",
    rating: 4.7,
    bio: "Expert in traditional Panchakarma therapies and joint pain management.",
  ),
];