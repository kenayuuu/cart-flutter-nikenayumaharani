import 'dart:convert';
import 'package:ecommerce_docker/screen/AddProductPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/ModelProduct.dart';
import 'DetailListPage.dart';
import 'CartListPage.dart';
import 'EditProductPage.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final String productUrl = "http://192.168.1.39:3000/products";
  final String cartUrl = "http://localhost:8000/api/carts";

  List<ModelProduct> products = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // ================= FETCH =================
  Future<void> fetchProducts() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final res = await http.get(Uri.parse(productUrl));
      if (res.statusCode == 200) {
        products = modelProductFromJson(res.body);
      } else {
        throw Exception("Failed load products");
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // ================= ADD TO CART =================
  Future<void> addToCart(int productId) async {
    await http.post(
      Uri.parse(cartUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"product_id": productId, "quantity": 1}),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Ditambahkan ke keranjang")));
  }

  // ================= DELETE PRODUCT =================
  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse("$productUrl/$id"));

    if (res.statusCode == 200 && mounted) {
      setState(() {
        products.removeWhere((p) => p.id == id);
      });
    }
  }

  // ================= EDIT PRODUCT =================
  Future<void> editProduct(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductPage(product: products[index]),
      ),
    );

    if (result != null && result is ModelProduct) {
      setState(() {
        products[index] = result; // 🔥 INI KUNCINYA
      });
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              );
              if (result == true) fetchProducts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartListPage()),
              );
            },
          ),
        ],
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    key: ValueKey(product.id), // 🔥 FIX UTAMA
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailListPage(product: product),
                                  ),
                                ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.image, size: 50),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text("\$${product.price}"),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => editProduct(index),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => deleteProduct(product.id),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    onPressed: () => addToCart(product.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
