// Cart.dart
import 'dart:convert';

class CartItem {
  int id;
  int productId;
  String name;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    productId: json["product_id"] ?? 0,
    name: json["name"],
    quantity: json["quantity"],
    price: (json["price"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "name": name,
    "quantity": quantity,
    "price": price,
  };
}

class Cart {
  List<CartItem> items;
  double total;

  Cart({required this.items, required this.total});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    items: List<CartItem>.from(json["items"].map((x) => CartItem.fromJson(x))),
    total: (json["total"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total": total,
  };
}
