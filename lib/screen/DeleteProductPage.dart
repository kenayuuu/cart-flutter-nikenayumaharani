import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteProductPage extends StatelessWidget {
  final int productId;
  const DeleteProductPage({super.key, required this.productId});

  final String productUrl = "http://192.168.1.39:3000/products";

  Future<void> deleteProduct(BuildContext context) async {
    try {
      final res = await http.delete(Uri.parse('$productUrl/$productId'));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Product deleted!")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed: ${res.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Product")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => deleteProduct(context),
          child: const Text("Confirm Delete"),
        ),
      ),
    );
  }
}
