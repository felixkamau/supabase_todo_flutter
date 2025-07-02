import 'package:flutter/material.dart';
import 'package:flutter_db/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final authService = AuthService();
  bool _obscure = true;
  // TextField controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();

  void _togglePswdVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Image  illustration
          Padding(
            padding: const EdgeInsets.only(
              left: 80,
              right: 80,
              bottom: 40,
              top: 100,
            ),
            child: Image.asset('lib/images/signup.png'),
          ),

          //   Some text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              textAlign: TextAlign.center,
              'Welcome, to tasker manage and keep track of your tasks.',

              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Sigup fields
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: TextField(
              controller: _emailController,
              cursorColor: Colors.grey,
              cursorHeight: 20,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                suffixIcon: Icon(Icons.email_outlined),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 144, 94, 1),
                    width: 2,
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                labelText: "Email",
                hint: Text("Email"),
              ),
            ),
          ),

          // Password field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: TextField(
              controller: _passwordController,
              obscureText: _obscure,
              cursorColor: Colors.grey,
              cursorHeight: 20,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                suffixIcon: IconButton(
                  onPressed: _togglePswdVisibility,
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 144, 94, 1),
                    width: 2,
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                labelText: "Password",
                hintText: "Password",
              ),
            ),
          ),

          // Confirm Pswd
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: TextField(
              controller: _confirmPassword,
              obscureText: _obscure,
              cursorColor: Colors.grey,
              cursorHeight: 20,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: _togglePswdVisibility,
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 144, 94, 1),
                    width: 2,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),

                hintText: "Confirm Password",
                labelText: "Confirm",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
