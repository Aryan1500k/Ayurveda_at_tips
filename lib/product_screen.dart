import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'models/product_item.dart';

// --- UPDATED DATA MODEL FOR REAL-LIFE APP ---
class Product {
  final String name;
  final double price;
  final String description;
  final String category;
  final List<String> worksFor;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.worksFor,
  });

  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      name: data['name']?.toString() ?? 'Unnamed Product',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description']?.toString() ?? 'No description available.',
      category: data['category']?.toString() ?? 'General',
      worksFor: data['worksFor'] is List ? List<String>.from(data['worksFor']) : [],
    );
  }
}

class ProductScreen extends StatefulWidget {
  final VoidCallback onTalkToExpert;

  const ProductScreen({super.key, required this.onTalkToExpert});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _selectedCategory = "Daily Care";
  final List<ProductItem> _cartItems = [];
  final Color themeBrown = const Color(0xFF8B6B23);

  void _addToCart(Product product) {
    setState(() {
      int index = _cartItems.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(ProductItem(name: product.name, price: product.price.toInt()));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: themeBrown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        title: const Text("Marketplace",
            style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        // --- FIXED: ONE WORKING CART ICON WITH ACTION ---
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Curated for Your Balance",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Playfair Display', fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // --- HORIZONTAL CATEGORY SELECTOR ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ["Daily Care", "Digestion", "Stress & Sleep", "Hair & Skin"].map((cat) =>
                  GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == cat ? themeBrown : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                      ),
                      child: Text(cat,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: _selectedCategory == cat ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
              ).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // --- DYNAMIC PRODUCT LIST ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('category', isEqualTo: _selectedCategory)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Error loading products"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: themeBrown));
                }
                final products = snapshot.data!.docs.map((doc) {
                  return Product.fromFirestore(doc.data() as Map<String, dynamic>);
                }).toList();
                if (products.isEmpty) {
                  return const Center(child: Text("No products found in this category."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: products.length,
                  itemBuilder: (context, index) => _buildProductCard(products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    const Color cardBeige = Color(0xFFFEFAF2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardBeige,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 12),

          if (product.worksFor.isNotEmpty) _buildWorksForPill(product),

          const SizedBox(height: 12),
          _buildBulletPoints(),

          const SizedBox(height: 25),
          _buildPriceRow(product),

          const SizedBox(height: 20),
          const Divider(color: Colors.black12, thickness: 1), // Divider moved to bottom
        ],
      ),
    );
  }

  Widget _buildWorksForPill(Product product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Works for: ",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          ...product.worksFor.map((dosha) => _buildDoshaIcon(dosha)).toList(),
        ],
      ),
    );
  }

  Widget _buildPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "₹${product.price.toStringAsFixed(0)}",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: () => _addToCart(product),
          icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: Colors.white),
          label: const Text("Add to cart",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeBrown,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }

  Widget _buildDoshaIcon(String dosha) {
    IconData icon;
    Color color;
    if (dosha == 'Vata') {
      icon = Icons.air;
      color = const Color(0xFFB3E5FC);
    } else if (dosha == 'Pitta') {
      icon = Icons.local_fire_department;
      color = const Color(0xFFFFCC80);
    } else {
      icon = Icons.water_drop;
      color = const Color(0xFFA5D6A7);
    }

    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 12, color: Colors.white),
    );
  }

  Widget _buildBulletPoints() {
    List<String> points = ["Supports healthy digestion", "Natural cleansing", "Promotes balance"];
    return Wrap(
      spacing: 15,
      runSpacing: 8,
      children: points.map((p) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 14, color: themeBrown),
          const SizedBox(width: 5),
          Text(p, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      )).toList(),
    );
  }
}