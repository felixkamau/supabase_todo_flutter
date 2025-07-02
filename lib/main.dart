import 'package:flutter/material.dart';
import 'package:flutter_db/auth/auth_gate.dart';
import 'package:flutter_db/pages/signup_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // load env varibles
  await dotenv.load(fileName: '.env');
  // Initialise supabase
  final anonkey = dotenv.env['SUPABASE_ANON_KEY'];
  final url = dotenv.env['SUPABASE_URL'];

  // Check null since Supabase doesn't non-nullable values
  if (anonkey == null || url == null) {
    throw Exception("Missing SUPABASE_ANON_KEY or SUPABASE_URL in .env file");
  }
  await Supabase.initialize(anonKey: anonkey, url: url);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO replace HomePage() with AuthGate()
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignupPage());
  }
}
