import 'package:flutter/material.dart';
import 'package:flutter_db/pages/home_page.dart';
import 'package:flutter_db/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) { 
    return StreamBuilder(
      // Listen to auth state
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // if is loadin show
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); 
        }

        // check id their is a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;
 
        if (session != null) {
          return HomePage(); // TODO implement the HomePage
        } else {
          return LoginPage(); // TODO implemeny the LoginPage
        }
      },
    );
  }
}
