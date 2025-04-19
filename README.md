# Elma

A Flutter-based mobile application for exploring and booking experiences.

## Team Members & Contributions

- **Raamiz Khan Niazi**: Explore page, Details page, App navigation integration
- **Mohammed Sateh Salem**: Checkout pages, Splash page, App navigation integration
- **Ashwin Velanjeri**: Login & Sign up pages
- **Emir Gılbaz**: Search by city functionality
- **Mert Seçen**: Cart and Payment success screens
- **Batu Taşlı**: Messaging system

Raamiz Khan Niazi and Mohammed Sateh Salem collaborated on integrating the app's navigation flow to create a seamless user experience.

## Design Elements

### Typography
The app uses **Poppins** as its primary font family, a modern sans-serif typeface that provides excellent readability and a clean aesthetic across all screens:
- Regular text (body content): Poppins Regular
- Medium emphasis text: Poppins Medium (weight 500)
- Section titles and buttons: Poppins SemiBold (weight 600)
- Screen titles and important elements: Poppins Bold (weight 700)
- Italicized text for emphasis: Poppins Italic

### Colors
- **Primary Color**: Fresh green (#53CF01) - Used for primary actions and brand identity
- **Accent Color**: Black - Used for text and secondary elements
- **Background Color**: White - Provides a clean, minimalist base for content

## App Screens

### Authentication & Onboarding
- **Splash Screen**: Initial loading screen displaying the app logo before transitioning to the Welcome screen.
- **Welcome Screen**: Introduction screen with app branding and options to log in or sign up.
- **Login Screen**: User authentication screen with email/password fields and social login options.
- **Signup Screen**: New user registration with form validation and social signup options.

### Core Functionality
- **Explore Screen**: Main dashboard displaying service provider listings with filtering by categories, featuring image carousels and service details.
- **Search Screen**: City-based search functionality allowing users to find services in specific locations across Turkey.
- **Service Provider Page**: Detailed view of a service provider showing their offerings, reviews, and booking options.
- **Cart Screen**: Shopping cart showing selected services before proceeding to checkout.
- **Checkout Page**: Payment processing screen with multiple payment method options (credit card, PayPal, Apple Pay).
- **Payment Success Screen**: Confirmation page displayed after successful transaction completion.

### User Engagement
- **Profile Page**: User account management and personal information.
- **Inbox**: Chat conversation list showing all messaging threads.
- **Message Screen**: Individual chat interface for communicating with service providers.

## Navigation Flow

1. **App Launch**: Splash Screen → Welcome Screen
2. **Authentication**: Welcome Screen → Login/Signup → Explore Screen
3. **Main Experience Flow**:
   - Explore Screen (main hub with bottom navigation)
   - Service browsing: Explore → Service Provider Details
   - Booking process: Service Provider → Cart → Checkout → Payment Success
   - Search functionality: Explore → Search → Results in Explore
4. **Communication Flow**: Inbox → Individual Message Threads
5. **User Management**: Profile page accessible from bottom navigation

The app uses a combination of stack-based navigation for linear flows and bottom navigation for switching between main sections (Explore, Wishlist, Services, Inbox, Profile).

## User Guide: Navigation & Button Functionality

### Splash & Welcome
- The **Splash Screen** will automatically transition to the Welcome Screen after 5 seconds.
- On the **Welcome Screen**, both "Log in" and "Sign Up" buttons are functional and will navigate to their respective screens.

### Authentication
- On the **Login Screen**:
  - The "Continue" button will become active once valid email and password are entered
  - Social login buttons (Google, Facebook, Apple) are **not functional** (placeholder UI only)
  - The "X" (close) button at the top left returns to the Welcome Screen
- On the **Signup Screen**:
  - The "Continue" button will become active once all validation criteria are met
  - Social signup buttons (Google, Facebook, Apple) are **not functional** (placeholder UI only)
  - The "X" (close) button at the top left returns to the Welcome Screen

### Main Screens
- On the **Explore Screen**:
  - The search bar at the top navigates to the Search Screen
  - Tapping a category tab filters the listings (basic functionality)
  - Tapping on a service provider card navigates to the Service Provider Page
  - The "Map" floating button is **not functional** (shows a notification message only)
  - Bottom navigation tabs: only "Explore", "Inbox" and "Profile" are functional
- On the **Service Provider Page**:
  - Scroll down to view details and services
  - The "Book" button navigates to the Checkout flow
  - The back button returns to the Explore Screen

### Booking & Payment
- On the **Checkout Page**:
  - Payment method selection tabs are functional
  - "Confirm Payment" button navigates to the Payment Success Screen
- On the **Payment Success Screen**:
  - "Back to Home" button returns to the Explore Screen

### Communication
- On the **Inbox Screen**:
  - Tap on any conversation to open the Message Screen
  - The back button returns to the previous screen
- On the **Message Screen**:
  - Type in the text field and send messages using the send button
  - The back button returns to the Inbox Screen

### Profile & Settings
- On the **Profile Page**:
  - Most settings buttons are **not functional** (placeholder UI only)
  - The back button returns to the previous screen

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.