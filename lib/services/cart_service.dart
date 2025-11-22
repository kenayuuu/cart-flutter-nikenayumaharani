import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ModelCart.dart';
import '../config/api.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;

  CartService._internal();

  Future<Cart> fetchCart() async {
    final response = await http.get(Uri.parse(ApiConfig.carts));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return Cart.fromJson(data);
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future<void> deleteCartItem(int itemId) async {
    print('Deleting item $itemId');
    final response = await http.delete(Uri.parse('${ApiConfig.carts}/$itemId'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      // Success - item deleted
      return;
    } else {
      throw Exception('Failed to delete item: ${response.statusCode}');
    }
  }
}
