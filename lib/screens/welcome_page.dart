// lib/screens/welcome_page.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppPaddings.defaultPadding,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Logo image (use your asset or network image)
              Image.asset(
                'assets/elma_logo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 40),
              // Welcome message
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: AppTextStyle.titleLarge.copyWith(
                    fontSize: 54,
                    color: AppColors.primary,
                  ),
                  children: const [
                    TextSpan(text: "Welcome to \n"),
                    TextSpan(
                      text: "Elma.\n",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: "Let's get started!"),
                  ],
                ),
              ),
              const Spacer(),
              // Log in button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    textStyle: AppTextStyle.labelLarge.copyWith(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text("Log in"),
                ),
              ),
              const SizedBox(height: 16),
              // Sign Up button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    textStyle: AppTextStyle.labelLarge.copyWith(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
