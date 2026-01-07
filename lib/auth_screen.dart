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

  bool _isLoading = false;
  bool isLogin = true;

  // Password Reset Logic
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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isLogin) {
        // THIS IS YOUR UPDATED LOGIN LOGIC
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // SIGN UP logic
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      // YOUR DETAILED ERROR HANDLING
      String errorMessage = "Authentication Failed";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is badly formatted.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already registered. Please login.";
      } else {
        errorMessage = e.message ?? "An unknown error occurred.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F3EE),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center( // Wrapped in Center for better vertical alignment
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.spa, size: 80, color: Color(0xFF009460)),
                const SizedBox(height: 20),
                Text(isLogin ? "Welcome Back" : "Create Account",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress, // Better mobile experience
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF009460)),
                    )
                ),
                const SizedBox(height: 15),
                TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF009460)),
                    )
                ),

                if (isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF009460))),
                    ),
                  ),

                const SizedBox(height: 30),

                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF009460))
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009460),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: _submitAuth,
                  child: Text(isLogin ? "Login" : "Sign Up",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),

                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      // Clear controllers when switching between login/signup
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  },
                  child: Text(isLogin ? "Don't have an account? Sign Up" : "Have an account? Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}