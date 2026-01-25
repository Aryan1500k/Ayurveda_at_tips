class ProductItem {
  final String name;
  final int price;
  int quantity;

  ProductItem({required this.name, required this.price, this.quantity = 1});
}