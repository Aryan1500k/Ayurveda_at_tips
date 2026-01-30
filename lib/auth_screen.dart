import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  // Existing Email/Password Logic
  Future<void> _submit() async {
    // Validate basic input first
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    setState(() => _isLoading = true); // Start the spinner

    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // If success, main.dart StreamBuilder handles navigation automatically
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Show the actual error so you know why it's failing
      String errorMsg = e.message ?? "Authentication failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred: $e")),
      );
    } finally {
      // THIS IS THE FIX: This line always runs, stopping the infinite spinner
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Google Sign-In Logic Placeholder
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Reset any existing session first
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Google Login Error: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.spa_outlined, size: 80, color: Color(0xFF8B6B23)),
              const SizedBox(height: 20),
              const Text(
                "AYURVEDA",
                style: TextStyle(
                  fontFamily: 'Trajan Pro',
                  fontSize: 28,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A6344),
                ),
              ),
              const Text("AT TIPS", style: TextStyle(letterSpacing: 2, fontSize: 12)),
              const SizedBox(height: 40),

              // --- Auth Card ---
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  children: [
                    Text(_isLogin ? "Welcome Back" : "Create Account", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(_isLogin ? "Login to continue" : "Start your journey", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 30),

                    if (!_isLogin) ...[
                      _buildTextField(_nameController, "Full Name", Icons.person_outline),
                      const SizedBox(height: 15),
                    ],
                    _buildTextField(_emailController, "Email Address", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    _buildTextField(_passwordController, "Password", Icons.lock_outline, isPassword: true),

                    const SizedBox(height: 30),

                    _isLoading
                        ? const CircularProgressIndicator(color: Color(0xFF8B6B23))
                        : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B6B23),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: Text(_isLogin ? "Login" : "Sign Up", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 20),
                    const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey, fontSize: 12))), Expanded(child: Divider())]),
                    const SizedBox(height: 20),

                    // --- NEW GOOGLE SIGN IN BUTTON ---
                    OutlinedButton.icon(
                      onPressed: _signInWithGoogle,
                      icon: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png', height: 20),
                      label: const Text("Continue with Google", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        side: const BorderSide(color: Color(0xFFF1F1F1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: RichText(
                  text: TextSpan(
                    text: _isLogin ? "Don't have an account? " : "Already have an account? ",
                    style: const TextStyle(color: Colors.grey),
                    children: [TextSpan(text: _isLogin ? "Sign Up" : "Login", style: const TextStyle(color: Color(0xFF8B6B23), fontWeight: FontWeight.bold))],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8F9F4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}