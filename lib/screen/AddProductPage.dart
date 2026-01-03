import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/ModelProduct.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final String productUrl = "http://192.168.1.39:3000/products";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = {
      "name": nameController.text,
      "price": double.parse(priceController.text),
      "description": descriptionController.text,
    };

    try {
      final res = await http.post(
        Uri.parse(productUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Product added!")));
        Navigator.pop(context, true); // return true to refresh list
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
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator:
                    (value) => value!.isEmpty ? "Enter product name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter price" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator:
                    (value) => value!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: addProduct,
                child: const Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
