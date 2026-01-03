import 'dart:convert';
import 'package:ecommerce_docker/config/api.dart';
import 'package:ecommerce_docker/model/ModelUser.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse(ApiConfig.users));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<UserModel> getUserDetail(int id) async {
    final response = await http.get(Uri.parse("${ApiConfig.users}/$id"));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("User not found");
    }
  }

  Future<void> addUser(String name, String email, String role) async {
    final response = await http.post(
      Uri.parse(ApiConfig.users),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "role": role}),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add user");
    }
  }
}
