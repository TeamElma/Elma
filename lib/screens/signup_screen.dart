// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import '../utils/constants.dart';
import '../widgets/social_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // For loading indicator
  
  // Add validation error messages
  String? _emailError;
  String? _passwordError;

  bool get _canContinue =>
      _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _emailError == null &&
          _passwordError == null;

  // Add validation functions
  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = "Email is required";
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = "Please enter a valid email address";
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = "Password is required";
      } else if (value.length < 6) {
        _passwordError = "Password must be at least 6 characters";
      } else if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
        _passwordError = "Password must contain at least one uppercase letter";
      } else if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
        _passwordError = "Password must contain at least one number";
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> _signUp() async {
    if (!_canContinue) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation will be handled by AuthWrapper in main.dart
      // if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/explore', (route) => false);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred. Please try again.";
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An unexpected error occurred: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Stack(
          children: [
            // White card
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: AppPaddings.defaultPadding,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Close + centered title
                      SizedBox(
                        height: 40,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.black),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorText: _emailError,
                        ),
                        onChanged: (value) {
                          _validateEmail(value);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorText: _passwordError,
                          helperText: "Password must be at least 6 characters, contain an uppercase letter and a number",
                          helperMaxLines: 2,
                        ),
                        onChanged: (value) {
                          _validatePassword(value);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 24),

                      // Continue → ExploreScreen (clears back stack)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canContinue && !_isLoading
                              ? AppColors.primary
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _canContinue && !_isLoading ? _signUp : null,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)
                              )
                            : const Text(
                                "Continue",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child:
                            Text("or", style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Social Buttons
                      SocialButton(
                        asset: 'assets/google_logo.png',
                        label: 'Continue with Google',
                        onPressed: () {/* TODO */},
                      ),
                      const SizedBox(height: 8),
                      SocialButton(
                        asset: 'assets/facebook_logo.png',
                        label: 'Continue with Facebook',
                        onPressed: () {/* TODO */},
                      ),
                      const SizedBox(height: 8),
                      SocialButton(
                        asset: 'assets/apple_logo.png',
                        label: 'Continue with Apple',
                        onPressed: () {/* TODO */},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
