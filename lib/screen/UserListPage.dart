import 'package:ecommerce_docker/model/ModelUser.dart';
import 'package:ecommerce_docker/screen/UserDetailPage.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'UserAddPage.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final UserService _service = UserService();

  late Future<List<UserModel>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = _service.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      _futureUsers = _service.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserAddPage()),
          );

          if (result == true) {
            _refreshUsers();
          }
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final u = users[index];
              return Card(
                child: ListTile(
                  title: Text(u.name),
                  subtitle: Text(u.email),
                  trailing: Text(u.role),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailPage(id: u.id),
                      ),
                    );

                    if (result == true) {
                      _refreshUsers();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
