// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:provider/provider.dart'; // Import Provider
import 'package:firebase_app_check/firebase_app_check.dart'; // Import App Check
import 'firebase_options.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate App Check. 
  // IMPORTANT: For emulators/debug, you might need to use the debug provider.
  // For production, ensure you have the correct providers configured (Play Integrity for Android, DeviceCheck for iOS).
  await FirebaseAppCheck.instance.activate(
    // Use the debug provider for emulators. 
    // You'll see a debug token in your console log when you run the app the first time.
    // You need to register this token in the Firebase console (App Check > Apps > Your App > Manage debug tokens).
    // Alternatively, for web or if you have specific needs:
    // webProvider: ReCaptchaV3Provider('YOUR_RECAPTCHA_V3_SITE_KEY'), 
    // androidProvider: AndroidProvider.debug, // Or AndroidProvider.playIntegrity
    // appleProvider: AppleProvider.debug, // Or AppleProvider.deviceCheck // Or AppleProvider.appAttest
    androidProvider: AndroidProvider.debug, // Using debug provider for Android emulator
    appleProvider: AppleProvider.debug, // Using debug provider for iOS simulator (if you use it)
  );

  // runApp(const MyApp()); // We'll wrap MyApp with StreamProvider
  runApp(
    StreamProvider<User?>.value( // Provide the User stream
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      child: const MyApp(),
    ),
  );
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
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      // home: const SplashPage(), // home will be handled by AuthWrapper
      home: const AuthWrapper(), // New AuthWrapper to decide initial screen
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

// New Widget to handle initial screen based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    print('AuthWrapper: Building...'); // DEBUG PRINT
    if (firebaseUser != null) {
      print('AuthWrapper: User is LOGGED IN - UID: ${firebaseUser.uid}'); // DEBUG PRINT
      return const ExploreScreen();
    } else {
      print('AuthWrapper: User is LOGGED OUT'); // DEBUG PRINT
      return const WelcomeScreen();
    }
  }
}
