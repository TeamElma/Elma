import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
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
      } else {
        _passwordError = null;
      }
    });
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
                      // Close + Title
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Email Field
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

                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorText: _passwordError,
                        ),
                        onChanged: (value) {
                          _validatePassword(value);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 24),

                      // Continue Button (reset stack to Explore)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canContinue
                              ? AppColors.primary
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _canContinue
                            ? () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/explore',
                                (route) => false,
                          );
                        }
                            : null,
                        child: const Text(
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
                            child: Text("or",
                                style:
                                TextStyle(color: Colors.grey, fontSize: 14)),
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
