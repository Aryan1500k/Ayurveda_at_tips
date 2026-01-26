import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Note: Ensure you have 'google_sign_in' in your pubspec.yaml
// import 'package:google_sign_in/google_sign_in.dart';

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
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text);
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Authentication failed");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Google Sign-In Logic Placeholder
  Future<void> _signInWithGoogle() async {
    // You would typically implement the GoogleSignIn() flow here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Connecting to Google..."), backgroundColor: Color(0xFF8B6B23)),
    );
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