/*
- Here we create a AuthService class
- Which will have the methods:
  => getEmail and userName
  => logOut()w
  => signUp and signIn
*/

import 'package:flutter_db/utils/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // create our supabse instance
  final _supabaseClient = supabaseClient;

  // Signup with email and pswd
  Future<AuthResponse> signUpWithEmailandPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signUp(email: email, password: password);
  }

  // Signin with email and pswd
  Future<AuthResponse> signInWithEmailandPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  // Log out
  Future<void> logOut() async { 
    await _supabaseClient.auth.signOut();
  }

  // get user info
  String? getEmail() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
