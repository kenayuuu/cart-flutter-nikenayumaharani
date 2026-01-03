import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserAddPage extends StatefulWidget {
  @override
  _UserAddPageState createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = UserService();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController role = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                controller: role,
                decoration: InputDecoration(labelText: "Role"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _service.addUser(name.text, email.text, role.text);

                  Navigator.pop(context, true);
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
