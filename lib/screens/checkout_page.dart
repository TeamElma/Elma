// lib/screens/checkout_page.dart

import 'package:flutter/material.dart';
import 'package:elma/models/service_model.dart'; // Import ServiceModel
import '../utils/constants.dart';

enum PaymentMethod { card, paypal, applePay }

class CheckoutPage extends StatefulWidget {
  // const CheckoutPage({Key? key}) : super(key: key); // Old constructor
  final ServiceModel? serviceToCheckout; // To receive the service

  const CheckoutPage({Key? key, this.serviceToCheckout}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;

  // Controllers for payment fields.
  final _cardHolderController   = TextEditingController();
  final _cardNumberController   = TextEditingController();
  final _expiryController       = TextEditingController();
  final _cvvController          = TextEditingController();
  final _paypalEmailController  = TextEditingController();

  // Dummy data for services acquired - will be replaced by passed service
  // final List<Map<String, dynamic>> _services = [
  //   {'name': 'Painting',       'cost': 750.00},
  //   {'name': 'Electrical',     'cost': 500.00},
  //   {'name': 'Transportation', 'cost': 200.00},
  // ];
  ServiceModel? _service;

  @override
  void initState() {
    super.initState();
    // Try to get service from widget arguments if not directly passed (for route navigation)
    // This is a bit redundant if always passing to constructor, but safe for named routes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.serviceToCheckout == null && ModalRoute.of(context)?.settings.arguments != null) {
        setState(() {
          _service = ModalRoute.of(context)!.settings.arguments as ServiceModel?;
        });
      } else {
        _service = widget.serviceToCheckout;
      }
       if (_service == null) {
        // Fallback or error if no service is provided - might navigate back or show error
        print("Error: CheckoutPage opened without a service model.");
        // You might want to Navigator.pop(context) here or show a message
      }
    });
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _paypalEmailController.dispose();
    super.dispose();
  }

  void _onConfirmPayment() {
    // Navigate to success screen, clearing this page off the stack:
    Navigator.pushReplacementNamed(context, '/payment-success');
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total from the passed service
    final double totalCost = _service?.priceInfo?.amount ?? 0.00;
    final String serviceName = _service?.title ?? "Selected Service";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Checkout',
          style: AppTextStyle.titleLarge.copyWith(color: AppColors.accent),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: AppPaddings.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company name
                  Text("XYZ Services Ltd.", style: AppTextStyle.titleLarge),
                  const SizedBox(height: 8),

                  // Services acquired
                  Text("Services Acquired:",
                      style: AppTextStyle.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  // Display the single service being checked out
                  if (_service != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(serviceName, style: AppTextStyle.bodyLarge, overflow: TextOverflow.ellipsis)),
                          Text("\$${totalCost.toStringAsFixed(2)}",
                              style: AppTextStyle.bodyLarge),
                        ],
                      ),
                    )
                  else
                     Text("No service selected for checkout.", style: AppTextStyle.bodyLarge),
                  const Divider(height: 24, thickness: 1),

                  // Reservation details
                  Text("Reservation Details:",
                      style: AppTextStyle.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text("Date & Time: April 20, 2025, 2:00 PM",
                      style: AppTextStyle.bodyLarge),
                  const SizedBox(height: 4),
                  Text("Location: 123 Main Street, New York, NY",
                      style: AppTextStyle.bodyLarge),
                  const Divider(height: 24, thickness: 1),

                  // Total
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total: \$${totalCost.toStringAsFixed(2)}",
                      style: AppTextStyle.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment method selector
                  Text("Select Payment Method:",
                      style: AppTextStyle.bodyLarge
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPaymentOption(
                        asset: 'assets/card.png',
                        method: PaymentMethod.card,
                      ),
                      const SizedBox(width: 16),
                      _buildPaymentOption(
                        asset: 'assets/Paypal.png',
                        method: PaymentMethod.paypal,
                      ),
                      const SizedBox(width: 16),
                      _buildPaymentOption(
                        asset: 'assets/apple.png',
                        method: PaymentMethod.applePay,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Dynamic form
                  if (_selectedPaymentMethod == PaymentMethod.card)
                    _buildCardPaymentForm(),
                  if (_selectedPaymentMethod == PaymentMethod.paypal)
                    _buildPaypalPaymentForm(),
                  if (_selectedPaymentMethod == PaymentMethod.applePay)
                    _buildApplePayInfo(),

                  // bottom spacer
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: AppPaddings.defaultPadding,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle: AppTextStyle.labelLarge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _onConfirmPayment,
            child: const Text('Confirm Payment'),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      {required String asset, required PaymentMethod method}) =>
      GestureDetector(
        onTap: () => setState(() => _selectedPaymentMethod = method),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
                color: _selectedPaymentMethod == method
                    ? AppColors.primary
                    : Colors.transparent,
                width: _selectedPaymentMethod == method ? 2 : 0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(asset, width: 80, height: 50),
        ),
      );

  Widget _buildCardPaymentForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Enter Card Details",
          style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(
        controller: _cardHolderController,
        decoration: InputDecoration(
          labelText: "Cardholder Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _cardNumberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Card Number",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _expiryController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "Expiry Date",
                hintText: "MM/YY",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CVV",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildPaypalPaymentForm() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Enter PayPal Details",
          style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(
        controller: _paypalEmailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "PayPal Email",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "You will be redirected to PayPal to complete your payment.",
        style: AppTextStyle.bodyLarge,
      ),
    ],
  );

  Widget _buildApplePayInfo() => Text(
    "Apple Pay Selected\nYou will be prompted on your device to authorize payment via Apple Pay.",
    style: AppTextStyle.bodyLarge,
  );
}
