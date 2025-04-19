import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  /// Path to the icon asset (e.g. 'assets/google_logo.png')
  final String asset;
  /// Label to show
  final String label;
  /// Called when tapped
  final VoidCallback onPressed;

  const SocialButton({
    Key? key,
    required this.asset,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,             // white background
        side: const BorderSide(color: Colors.grey),// grey border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      icon: Image.asset(asset, width: 24, height: 24),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      onPressed: onPressed,
    );
  }
}
