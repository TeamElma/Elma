// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();
  bool couponApplied = false;

  // Now only title & price—no 'img' field
  List<Map<String, dynamic>> cartItems = [
    {'title': 'A/C Maintenance', 'price': 49.99},
    {'title': 'Plumber',          'price': 59.99},
  ];

  double shipping = 5.99;
  double discount = 0.0;

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item['price'] as double);

  double get total => subtotal + shipping - discount;

  void applyCoupon() {
    final code = _couponController.text.trim().toLowerCase();
    if (code == 'green10') {
      setState(() {
        discount = 10.00;
        couponApplied = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Invalid Coupon"),
          content: const Text("Try something else"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK")),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // back to last screen
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Order summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),
          ...cartItems.map((item) => _cartTile(item)).toList(),
          const SizedBox(height: 20),
          _couponInput(),
          const SizedBox(height: 20),
          _priceRow('Subtotal', subtotal),
          _priceRow('Shipping', shipping),
          if (couponApplied) _priceRow('Discount', -discount),
          const Divider(thickness: 1),
          _priceRow('Total', total, isBold: true),
          const SizedBox(height: 20),
          _ecoLine(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/checkout'); // to checkout screen
            },
            child: const Text('Pay now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF028907),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartTile(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // No image here—just title & price
          Expanded(
            child: Text(item['title'] as String,
                style: const TextStyle(fontSize: 16)),
          ),
          Text("£${(item['price'] as double).toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _couponInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _couponController,
            decoration: InputDecoration(
              hintText: "Discount code",
              filled: true,
              fillColor: Colors.white,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: applyCoupon,
          child: const Text('Apply'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF028907),
            foregroundColor: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _priceRow(String label, double amount,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(
            (amount < 0 ? "- " : "") + "£${amount.abs().toStringAsFixed(2)}",
            style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          )
        ],
      ),
    );
  }

  Widget _ecoLine() {
    return Row(
      children: const [
        Icon(Icons.eco, size: 18, color: Colors.green),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "Every GreenPay order removes carbon from the air at no cost.",
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }
}
