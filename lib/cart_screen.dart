import 'package:flutter/material.dart';
import 'models/product_item.dart';

class CartScreen extends StatefulWidget {
  final List<ProductItem> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // Calculate the total sum of the cart
  double get totalSum {
    return widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontFamily: 'Trajan Pro', fontSize: 16)),
                            const SizedBox(height: 5),
                            Text("\$${item.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF8B6B23), borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                              onPressed: () => setState(() {
                                if (item.quantity > 1) item.quantity--;
                              }),
                            ),
                            Text("${item.quantity}", style: const TextStyle(color: Colors.white)),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white, size: 16),
                              onPressed: () => setState(() => item.quantity++),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () => setState(() => widget.cartItems.removeAt(index)),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          // Total Section
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Estimated Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Text("\$${totalSum.toStringAsFixed(2)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}