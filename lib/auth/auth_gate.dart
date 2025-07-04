/*
- Check/listen continously on Auth state change
- Listen to auth session and render based on session state

*/
import 'package:flutter/material.dart';
import 'package:flutter_db/pages/login_page.dart';
import 'package:flutter_db/pages/main_screen.dart';
// import 'package:flutter_db/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth statet
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // if is loading show
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if their a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return MainScreen(); // or any other screen/page
        } else {
          return LoginPage();
        }
      },
    );
  }
}
