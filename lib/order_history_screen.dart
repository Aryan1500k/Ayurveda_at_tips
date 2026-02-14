import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Color themeBrown = const Color(0xFF8B6B23);

  // --- 1. THE CANCEL LOGIC ---
  Future<void> _cancelOrder(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(docId).update({
        'status': 'Cancelled', // Updates the field in Firestore
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Cancelled Successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  // --- 2. CONFIRMATION DIALOG ---
  void _showCancelDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Order?"),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () {
              _cancelOrder(docId);
              Navigator.pop(context);
            },
            child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        title: const Text("My Orders",
            style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: userId == null
          ? const Center(child: Text("Please login to view orders"))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('buyerId', isEqualTo: userId)
            .orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading orders"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator(color: themeBrown));
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders placed yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var order = doc.data() as Map<String, dynamic>;
              // Pass the doc.id (the ID from the middle column in Firestore)
              return _buildOrderCard(doc.id, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(String docId, Map<String, dynamic> order) {
    DateTime date = (order['orderDate'] as Timestamp).toDate();
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);
    String status = order['status'] ?? 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              _buildStatusPill(status),
            ],
          ),
          const Divider(height: 30),
          ...(order['items'] as List).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text("${item['name']} x${item['quantity']}",
                style: const TextStyle(fontWeight: FontWeight.w500)),
          )),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: ₹${order['totalAmount']}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: themeBrown)),

              // --- THE FIX: ADDING THE BUTTON VISUALLY ---
              if (status == 'Pending')
                TextButton(
                  onPressed: () => _showCancelDialog(docId),
                  child: const Text("Cancel Order",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color = status == 'Delivered' ? Colors.green :
    status == 'Cancelled' ? Colors.red : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}