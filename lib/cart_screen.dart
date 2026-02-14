import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for dynamic user
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for orders collection
import 'checkout_screen.dart';
import 'models/product_item.dart';

class CartScreen extends StatefulWidget {
  final List<ProductItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color themeBrown = const Color(0xFF8B6B23);
  bool _isProcessing = false; // To prevent double-clicking the button

  // --- DYNAMIC ORDERING LOGIC ---
  Future<void> _placeOrder(List<ProductItem> items, double total) async {
    setState(() => _isProcessing = true);

    try {
      // 1. Get the current logged-in user dynamically
      final User? user = FirebaseAuth.instance.currentUser;

      // 2. Check if the user is logged in
      if (user == null || user.email == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please log in to place an order")),
          );
        }
        return;
      }

      // 3. Send the dynamic data to your "orders" collection
      await FirebaseFirestore.instance.collection('orders').add({
        'buyerEmail': user.email, // Dynamic Email
        'buyerId': user.uid,      // Dynamic ID
        'items': items.map((item) => {
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
        }).toList(),
        'totalAmount': total,
        'orderDate': FieldValue.serverTimestamp(), // Exact time of purchase
        'status': 'Pending',
      });

      // 4. Handle success
      if (mounted) {
        widget.cartItems.clear(); // Empty the cart after successful order
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order Placed Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Return to Marketplace
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        title: const Text("Your Cart",
            style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty", style: TextStyle(color: Colors.grey)))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.spa, color: Color(0xFF8B6B23), size: 40),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Qty: ${item.quantity}", style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text("₹${item.price * item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
          // Summary and Checkout Button
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("₹${total.toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeBrown)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  // Trigger the dynamic order function
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(cartItems: widget.cartItems, total: total),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeBrown,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Place Order",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}