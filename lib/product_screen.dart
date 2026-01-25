import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'models/product_item.dart'; // Ensure this model exists with name, price, and quantity

class ProductScreen extends StatefulWidget {
  final VoidCallback onTalkToExpert; // Callback to switch to Expert Tab (Index 3)

  const ProductScreen({super.key, required this.onTalkToExpert});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _selectedCategory = "Daily Care";
  List<ProductItem> _cartItems = []; // List to track items for the Cart Screen

  // Adds product to cart or increments quantity if already present
  void _addToCart(String name, int price) {
    setState(() {
      int index = _cartItems.indexWhere((item) => item.name == name);
      if (index != -1) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(ProductItem(name: name, price: price));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$name added to cart"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      appBar: AppBar(
        title: const Text("Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Shopping Cart with Real-time Badge
          IconButton(
            icon: Badge(
              label: Text("${_cartItems.length}"),
              isLabelVisible: _cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen(cartItems: _cartItems)),
            ).then((_) => setState(() {})), // Refresh state when returning from Cart
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Curated for\nYour Balance",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 26, height: 1.2)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Text("Products specially selected to support your unique constitution and wellness goals.",
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),

            // --- Horizontal Category Selector ---
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
                          color: _selectedCategory == cat ? const Color(0xFF8B6B23) : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: _selectedCategory == cat ? Colors.transparent : Colors.black12),
                        ),
                        child: Text(cat,
                            style: TextStyle(
                                color: _selectedCategory == cat ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ),
                    )
                ).toList(),
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(_selectedCategory, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),

            // --- Dynamic Product List ---
            _buildProductList(),

            // --- Bottom Navigation Section ---
            const SizedBox(height: 40),
            const Icon(Icons.people_outline, color: Colors.grey, size: 30),
            const SizedBox(height: 10),
            const Text("Not Sure Where to Start?", style: TextStyle(fontFamily: 'Trajan Pro', fontSize: 20)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Text("Speak with a certified Ayurvedic practitioner for personalized guidance.",
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
            ),
            ElevatedButton(
              onPressed: widget.onTalkToExpert, // Switches to Expert Tab
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B6B23),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Talk to an Expert", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Swaps content based on selected category
  Widget _buildProductList() {
    if (_selectedCategory == "Daily Care") {
      return Column(children: [
        _productCard("Triphala Digestive Complex", 29, "A time-honored blend for gentle, daily digestive support.", ["Supports digestion", "Natural cleansing"], [Colors.lightBlue, Colors.orange, Colors.green]),
        _productCard("Ashwagandha Calm", 35, "Adaptogenic herb to help your body adapt to stress.", ["Reduces stress", "Supports energy"], [Colors.lightBlue, Colors.green]),
      ]);
    } else if (_selectedCategory == "Digestion") {
      return Column(children: [
        _productCard("Digestive Spice Blend", 24, "A warming blend to kindle your digestive fire.", ["Enhances appetite", "Reduces bloating"], [Colors.lightBlue, Colors.green]),
      ]);
    } else if (_selectedCategory == "Stress & Sleep") {
      return Column(children: [
        _productCard("Brahmi Mind Clarity", 32, "Traditional herb for mental clarity and focus.", ["Enhances memory", "Reduces anxiety"], [Colors.lightBlue, Colors.orange]),
        _productCard("Deep Sleep Formula", 38, "Calming blend for restorative sleep.", ["Promotes relaxation", "Supports deep sleep"], [Colors.lightBlue, Colors.orange, Colors.green]),
      ]);
    } else { // Hair & Skin
      return Column(children: [
        _productCard("Nourishing Hair Oil", 28, "Brahmi and Amla blend for lustrous hair.", ["Strengthens roots", "Adds shine"], [Colors.lightBlue, Colors.orange, Colors.green]),
        _productCard("Radiance Face Serum", 45, "Kumkumadi serum for glowing skin.", ["Evens skin tone", "Nourishes deeply"], [Colors.lightBlue, Colors.orange, Colors.green]),
      ]);
    }
  }

  Widget _productCard(String name, int price, String desc, List<String> bulletPoints, List<Color> doshaColors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: const Color(0xFFFEFAF2), borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontFamily: 'Trajan Pro', fontSize: 22)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4))),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bulletPoints.map((point) => Row(children: [
                  const Icon(Icons.check, size: 14, color: Color(0xFF8B6B23)),
                  const SizedBox(width: 5),
                  Text(point, style: const TextStyle(fontSize: 11, color: Colors.black54))
                ])).toList(),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Text("Works for: ", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ...doshaColors.map((color) => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.circle, size: 12, color: color.withOpacity(0.5)),
              )).toList(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$$price", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _addToCart(name, price),
                icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: Colors.white),
                label: const Text("Add to cart", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B6B23),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}