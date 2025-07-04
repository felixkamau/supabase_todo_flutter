import 'package:flutter/material.dart';
import 'package:flutter_db/auth/auth_service.dart';
import 'package:flutter_db/pages/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Get AuthService()
  final authService = AuthService();
  bool _obscure = true;
  // Text controllers for email and pswd
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // try login in
    try {
      await authService.signInWithEmailandPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error $e")));
        print(e);
      }
    }
  }

  // Dispose the controllers for memory mgt
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo
            Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(
                left: 80,
                right: 80,
                bottom: 40,
                top: 60,
              ),
              child: Image.asset('lib/images/signup.png'),
            ),

            Padding(
              // padding: const EdgeInsets.all(20.0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: 'Tasker',
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(255, 114, 94, 1),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextSpan(
                      text: ', manage your daily task on the go',
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // add some sub-text
            SizedBox(height: 12),
            Text(
              "Keep track of you daily activity",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),

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
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintText: "Email",
                ),
              ),
            ),

            SizedBox(height: 6),

            Padding(
              // padding: const EdgeInsets.all(25.0),
              // padding: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 15),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: TextField(
                obscureText: _obscure,
                controller: _passwordController,
                cursorColor: Colors.grey,
                cursorHeight: 20,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
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
                  suffixIcon: IconButton(
                    onPressed: _toggleVisibility,
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintText: "password",
                ),
              ),
            ),

            // Button
            SizedBox(height: 5),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 114, 94, 1),
                  side: BorderSide.none,
                  shape: StadiumBorder(),
                ),
                child: Text("Login", style: TextStyle(color: Colors.white)),
              ),
            ),

            // Dont have an account
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              ),
              child: Text(
                "Don't have an account? Sign Up",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
