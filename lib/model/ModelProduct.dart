// To parse this JSON data, do
//
//     final modelProduct = modelProductFromJson(jsonString);

import 'dart:convert';

List<ModelProduct> modelProductFromJson(String str) => List<ModelProduct>.from(
  json.decode(str).map((x) => ModelProduct.fromJson(x)),
);

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
    price: json["price"]?.toDouble(),
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "Description": description,
  };
}
