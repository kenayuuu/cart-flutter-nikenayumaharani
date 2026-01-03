import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/ModelProduct.dart';

class EditProductPage extends StatefulWidget {
  final ModelProduct product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final String productUrl = "http://192.168.1.39:3000/products";

  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
  }

  Future<void> editProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final body = {
      "name": nameController.text,
      "price": double.parse(priceController.text),
      "description": descriptionController.text,
    };

    try {
      final res = await http.put(
        Uri.parse("$productUrl/${widget.product.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        // 🔥 BENTUK DATA BARU DARI INPUT SENDIRI
        final updatedProduct = ModelProduct(
          id: widget.product.id,
          name: body["name"] as String,
          price: body["price"] as double,
          description: body["description"] as String,
        );

        Navigator.pop(context, updatedProduct);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal update: ${res.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading ? null : editProduct,
                child:
                    loading
                        ? const CircularProgressIndicator()
                        : const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
