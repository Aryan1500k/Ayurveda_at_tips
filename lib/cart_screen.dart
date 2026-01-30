import 'package:flutter/material.dart';
import 'models/product_item.dart';

class CartScreen extends StatelessWidget {
  final List<ProductItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    const Color themeBrown = Color(0xFF8B6B23);
    double total = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        title: const Text("Your Cart", style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty", style: TextStyle(color: Colors.grey)))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.spa, color: themeBrown, size: 40),
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
                    Text("₹${total.toStringAsFixed(0)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeBrown)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {}, // Implement Payment Gateway
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeBrown,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Proceed to Checkout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}