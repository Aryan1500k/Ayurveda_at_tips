import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/product_item.dart';

class CheckoutScreen extends StatefulWidget {
  final List<ProductItem> cartItems;
  final double total;

  const CheckoutScreen({super.key, required this.cartItems, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  String _paymentMode = "Cash on Delivery"; // Default
  bool _isProcessing = false;

  Future<void> _confirmOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter address")));
      return;
    }

    setState(() => _isProcessing = true);
    final user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'buyerEmail': user?.email,
        'buyerId': user?.uid,
        'items': widget.cartItems.map((item) => {
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
        }).toList(),
        'totalAmount': widget.total,
        'shippingAddress': _addressController.text, // Added Address
        'paymentMode': _paymentMode, // Added Payment Mode
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });

      widget.cartItems.clear();
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst); // Back to Market
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order Placed!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _addressController, maxLines: 3, decoration: const InputDecoration(hintText: "Enter Full Address")),
            const SizedBox(height: 20),
            const Text("Payment Mode", style: TextStyle(fontWeight: FontWeight.bold)),
            ...["Cash on Delivery", "UPI", "Debit/Credit Card"].map((mode) => RadioListTile(
              title: Text(mode),
              value: mode,
              groupValue: _paymentMode,
              onChanged: (val) => setState(() => _paymentMode = val.toString()),
            )),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isProcessing ? null : _confirmOrder,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B6B23), minimumSize: const Size(double.infinity, 50)),
              child: _isProcessing ? const CircularProgressIndicator() : const Text("Confirm Order", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}