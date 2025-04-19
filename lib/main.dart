// lib/main.dart

import 'package:flutter/material.dart';
import 'utils/constants.dart';

// Core screens
import 'screens/splash_page.dart';
import 'screens/welcome_page.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/explore_page.dart';
import 'screens/service_provider_page.dart';
import 'screens/profile_page.dart';
import 'screens/booking_search_screen.dart';
import 'screens/PaymentSuccessScreen.dart';
import 'screens/checkout_page.dart';
import 'screens/cart_screen.dart';

// Messaging
import 'messaging/repositories/chat_repository.dart';
import 'screens/inbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Create one shared ChatRepository for the whole app
  static final ChatRepository _chatRepository = ChatRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        '/welcome': (c) => const WelcomeScreen(),
        '/login':   (c) => const LoginScreen(),
        '/signup':  (c) => const SignupScreen(),
        '/explore': (c) => const ExploreScreen(),
        '/details': (c) => const ServiceProviderPage(),
        '/profile': (c) => const ProfilePage(),
        '/search':  (c) => const BookingSearchScreen(),
        // Pass the shared ChatRepository into InboxScreen:
        '/inbox':  (c) => InboxScreen(chatRepository: _chatRepository),
        '/checkout': (c) => const CheckoutPage(),
        '/payment-success': (c) => const PaymentSuccessScreen(),
        '/cart': (c) => const CartScreen(),
      },
    );
  }
}
