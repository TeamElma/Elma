// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:provider/provider.dart'; // Import Provider
import 'package:firebase_app_check/firebase_app_check.dart'; // Import App Check
import 'firebase_options.dart';
import 'utils/constants.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:elma/utils/firestore_seed.dart'; // Import the seed utility

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

  // Initialize Firebase App Check
  // TODO: Replace 'your-recaptcha-v3-site-key' with your actual reCAPTCHA v3 site key for web.
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('your-recaptcha-v3-site-key'),
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
  );

  // ---- Conditionally run seed function ----
  // WARNING: This will write to your Firestore database.
  // Run it once, then comment it out or make it callable on demand.
  print("Value of kDebugMode: $kDebugMode"); // Added to check the value
  if (kDebugMode) { // Restoring this check
    // To ensure it runs only once per fresh install or when you explicitly want it,
    // you might use a more sophisticated check, e.g., SharedPreferences.
    // For now, this will run every time you start in debug mode.
    // Consider commenting this out after the first successful run.
    print("DEBUG MODE: Attempting to seed initial data...");
    await FirestoreSeed.seedInitialData();
    print("DEBUG MODE: Finished attempting to seed initial data.");
  } // Restoring this check
  // ---- End seed function call ----

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
