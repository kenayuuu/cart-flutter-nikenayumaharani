// To parse this JSON data, do
//
//     final modelProduct = modelProductFromJson(jsonString);

import 'dart:convert';

List<ModelProduct> modelProductFromJson(String str) {
  final jsonData = json.decode(str); // Map
  final List<dynamic> productsData = jsonData['data']; // ambil 'data'
  return productsData.map((e) => ModelProduct.fromJson(e)).toList();
}

String modelProductToJson(List<ModelProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelProduct {
  int id;
  String name;
  double price;
  String description;

  ModelProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ModelProduct.fromJson(Map<String, dynamic> json) => ModelProduct(
    id: json["id"],
    name: json["name"],
    price: (json["price"] as num).toDouble(),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
  };
}
