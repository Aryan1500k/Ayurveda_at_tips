import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 1. Add loading state variable
  bool _isLoading = false;
  bool isLogin = true;

  // 2. Password Reset Logic
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email to reset password")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent! Check your inbox.")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error sending reset email")),
      );
    }
  }

  Future<void> _submitAuth() async {
    // Start Loading
    setState(() => _isLoading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication Error")),
      );
    } finally {
      // Stop Loading
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F3EE),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView( // Added scroll view to prevent keyboard overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Icon(Icons.spa, size: 80, color: Color(0xFF009460)),
              const SizedBox(height: 20),
              Text(isLogin ? "Welcome Back" : "Create Account",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),

              // 3. Add Forgot Password Button
              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF009460))),
                  ),
                ),

              const SizedBox(height: 20),

              // 4. Show Spinner or Button based on _isLoading
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF009460))
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009460),
                    minimumSize: const Size(double.infinity, 50)
                ),
                onPressed: _submitAuth,
                child: Text(isLogin ? "Login" : "Sign Up", style: const TextStyle(color: Colors.white)),
              ),

              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? "Don't have an account? Sign Up" : "Have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
