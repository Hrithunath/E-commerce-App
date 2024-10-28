// lib/domain/model/cart_model.dart
class CartModel {
  final String productid;
  final String cartid;
  final int count;
  final String imageUrl;
  final String name;
  final String size;
  final int stock;
  final double price;

  CartModel({
    required this.productid,
    required this.cartid,
    required this.count,
    required this.imageUrl,
    required this.name,
    required this.size,
    required this.stock,
    required this.price,
  });
}
