import 'package:ecommerce_docker/model/ModelUser.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserDetailPage extends StatelessWidget {
  final int id;
  final _service = UserService();

  UserDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Detail")),
      body: FutureBuilder<UserModel>(
        future: _service.getUserDetail(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${user.name}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Email: ${user.email}"),
                SizedBox(height: 10),
                Text("Role: ${user.role}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
