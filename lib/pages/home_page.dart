import 'package:flutter/material.dart';
import 'package:flutter_db/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final authService = AuthService();
  void logout() async {
    authService.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page"),
        leading: IconButton(onPressed: logout, icon: Icon(Icons.logout)),
      ),
    );
  }
}
