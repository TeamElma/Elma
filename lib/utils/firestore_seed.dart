import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elma/models/user_model.dart';
import 'package:elma/models/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For current user if needed for createdBy fields
import 'dart:math'; // For random data
import 'package:uuid/uuid.dart'; // For generating unique IDs

class FirestoreSeed {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Random _random = Random();
  static const Uuid _uuid = Uuid();

  static final List<String> _categories = [
    // From ExplorePage, skipping "All"
    'Maintenance', 'Moving', 'Repairs', 'Cleaning', 'Lifestyle',
    'Design', 'Plumbing', 'Painting', 'Landscaping', 'Electrical',
    'HVAC', 'Tutoring', 'Catering', 'Events', 'Photography',
    'Consulting', 'Pet Care', 'Wellness', 'Automotive', 'Tech Support'
  ];

  static final List<String> _sampleImageUrls = [
    'https://images.unsplash.com/photo-1542744095-291d1f67b221?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHdvcmt8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    'https://images.unsplash.com/photo-1517048676732-d65bc937f952?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHdvcmt8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHdvcmt8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjd8fHdvcmt8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzB8fHdvcmt8ZW58MHx8MHx8fDA%3D&w=1000&q=80'
  ];

  static final List<String> _sampleLocations = [
    'Downtown Core', 'North Suburbs', 'Eastside Business Park', 'West End Residential', 'University District'
  ];

  static final List<String> _sampleTags = [
    'quick', 'reliable', 'expert', 'local', 'certified', 'insured', 'eco-friendly', '24/7', 'emergency', 'specialist'
  ];

  static Future<void> seedInitialData() async {
    print('Starting to seed initial data (enhanced version)...');

    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      print('SEEDER: No authenticated user. Skipping.');
      return;
    }
    String providerUid = currentUser.uid;
    print('SEEDER: Current user UID for seeding: $providerUid, Email: ${currentUser.email}');

    try {
      // Fetch existing user document from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(providerUid).get();
      Map<String, dynamic>? existingUserData = userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;

      String determinedDisplayName;
      String? determinedPhotoUrl;
      String userEmail = currentUser.email ?? 'provider_${_uuid.v4().substring(0, 8)}@example.com';

      // Determine Display Name
      if (existingUserData != null && existingUserData['displayName'] != null && (existingUserData['displayName'] as String).isNotEmpty) {
        determinedDisplayName = existingUserData['displayName'] as String;
      } else if (currentUser.displayName != null && currentUser.displayName!.isNotEmpty) {
        determinedDisplayName = currentUser.displayName!;
      } else {
        String firstName = _getRandomFirstName();
        String lastName = _getRandomLastName();
        determinedDisplayName = '$firstName $lastName';
      }

      // Determine Photo URL
      if (existingUserData != null && existingUserData['photoUrl'] != null && (existingUserData['photoUrl'] as String).isNotEmpty) {
        determinedPhotoUrl = existingUserData['photoUrl'] as String;
      } else if (currentUser.photoURL != null && currentUser.photoURL!.isNotEmpty) {
        determinedPhotoUrl = currentUser.photoURL;
      } else {
        // Generate if no photoUrl from Firestore or Auth, using the determinedDisplayName
        determinedPhotoUrl = _getSampleAvatarUrl(determinedDisplayName);
      }

      // 1. Create or Update the currently logged-in user as a Service Provider
      print('Attempting to seed/update provider data for UID: $providerUid');

      UserModel serviceProvider = UserModel(
        userId: providerUid,
        email: userEmail, // Use the determined email
        displayName: determinedDisplayName, // Use the determined display name
        isServiceProvider: true,
        photoUrl: determinedPhotoUrl, // Use the determined photo URL
        aboutMe: existingUserData?['aboutMe'] as String? ?? 'Passionate and experienced professional dedicated to providing top-quality services. My goal is to exceed client expectations on every project. I specialize in ${_categories[_random.nextInt(_categories.length)]} and ${_categories[_random.nextInt(_categories.length)]}.',
        providerName: existingUserData?['providerName'] as String? ?? '${determinedDisplayName}\'s ${_getBusinessSuffix()} Services',
        providerBio: existingUserData?['providerBio'] as String? ?? 'Your trusted partner for all things related to ${_categories[_random.nextInt(_categories.length)]}. With ${_random.nextInt(10) + 1} years of experience, we deliver excellence and customer satisfaction.',
        specialties: existingUserData?['specialties'] != null ? List<String>.from(existingUserData?['specialties']) : _getRandomSublist(_categories, 3),
        providerLocation: existingUserData?['providerLocation'] != null 
            ? LocationModel.fromMap(existingUserData?['providerLocation'])
            : LocationModel(
                addressString: '${_random.nextInt(2000) + 100} ${_getRandomStreetName()} St, Techville, FL ${_random.nextInt(90000) + 10000}',
                city: 'Techville',
                country: 'USA',
                postalCode: '${_random.nextInt(90000) + 10000}',
                geopoint: GeoPoint(28.5383 + (_random.nextDouble() * 0.2 - 0.1), -81.3792 + (_random.nextDouble() * 0.2 - 0.1)),
              ),
        experienceMonths: existingUserData?['experienceMonths'] as int? ?? (_random.nextInt(10) + 1) * 12,
        overallRating: existingUserData?['overallRating'] as double? ?? _random.nextDouble() * 1.5 + 3.5,
        totalServiceReviews: existingUserData?['totalServiceReviews'] as int? ?? _random.nextInt(200) + 10,
        isVerified: existingUserData?['isVerified'] as bool? ?? _random.nextBool(),
        phoneNumber: existingUserData?['phoneNumber'] as String? ?? '(${_random.nextInt(900) + 100}) 555-${_random.nextInt(9000) + 1000}',
        createdAt: existingUserData?['createdAt'] != null ? (existingUserData?['createdAt'] as Timestamp) : Timestamp.now(), // Preserve original creation if exists
        updatedAt: Timestamp.now(), // Always update this
      );

      await _firestore.collection('users').doc(providerUid).set(serviceProvider.toMap(), SetOptions(merge: true));
      print('SEEDER: User document for $providerUid seeded/updated with enhanced data.');

      // 2. Create Sample Services for this Provider (Two per category)
      final servicesCollection = _firestore.collection('services');
      
      // Simplified check: if ANY services exist for this provider, skip ALL service seeding for this run.
      // This prevents duplicate categories if run multiple times but doesn't selectively add missing ones.
      // For a full re-seed of services, ideally clear existing ones first.
      final existingServicesSnapshot = await servicesCollection.where('providerId', isEqualTo: providerUid).limit(1).get();
      if (existingServicesSnapshot.docs.isNotEmpty) {
        print('Services for provider $providerUid already exist. Skipping service seeding for categories.');
      } else {
        print('Seeding new services for provider $providerUid across multiple categories...');
        for (String category in _categories) {
          for (int i = 1; i <= 2; i++) { // Two services per category
            String serviceId = _uuid.v4();
            String serviceTitle = _getServiceTitle(category, i);
            
            ServiceModel service = ServiceModel(
              serviceId: serviceId,
              providerId: providerUid,
              providerName: serviceProvider.providerName,
              providerPhotoUrl: serviceProvider.photoUrl,
              title: serviceTitle,
              description: _getServiceDescription(serviceTitle, serviceProvider.displayName ?? "the provider"),
              category: category,
              priceInfo: PriceInfoModel(
                amount: (_random.nextInt(20) + 3) * 10.0, // $30 - $220 in increments of $10
                currency: 'USD',
                basis: _random.nextBool() ? 'fixed' : 'hourly',
              ),
              imageUrls: _getRandomSublist(_sampleImageUrls, _random.nextInt(3) + 1), // 1 to 3 images
              serviceLocation: ServiceLocationModel(
                addressString: 'Serves the ${_sampleLocations[_random.nextInt(_sampleLocations.length)]} area.',
                city: 'Techville',
                country: 'USA',
                // Optional: Add more specific lat/lng if needed for map features
              ),
              availability: _getSampleAvailability(),
              averageRating: _random.nextDouble() * 1.5 + 3.5, // 3.5 to 5.0
              totalReviews: _random.nextInt(100) + 5, // 5 to 105
              tags: _getRandomSublist(_sampleTags, _random.nextInt(3) + 2)..add(category.toLowerCase()), // 2-4 tags + category
              createdAt: Timestamp.now(),
              updatedAt: Timestamp.now(),
              isActive: true,
              providerIsVerified: serviceProvider.isVerified,
              providerExperienceMonths: serviceProvider.experienceMonths,
            );

            await servicesCollection.doc(serviceId).set(service.toMap());
            print('Seeded service: ${service.title} (Category: $category)');
          }
        }
      }
      print('Finished seeding initial data successfully (enhanced version)!');
    } catch (e, s) {
      print('Error seeding data (enhanced version): $e');
      print('Stack trace: $s');
    }
  }

  // --- Helper methods for generating random data ---

  static String _getRandomFirstName() {
    const names = ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Fiona', 'George', 'Hannah', 'Ian', 'Julia'];
    return names[_random.nextInt(names.length)];
  }

  static String _getRandomLastName() {
    const names = ['Smith', 'Jones', 'Williams', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson'];
    return names[_random.nextInt(names.length)];
  }
  
  static String _getSampleAvatarUrl(String nameSeed) {
    // Using pravatar.cc with a simple hash of the name to get a consistent-ish avatar
    final hash = nameSeed.hashCode % 100; // Keep it simple
    return 'https://i.pravatar.cc/150?img=$hash';
  }

  static String _getBusinessSuffix() {
    const suffixes = ['Pro', 'Experts', 'Solutions', 'Co', 'Enterprises', 'Group', 'Home', 'Local'];
    return suffixes[_random.nextInt(suffixes.length)];
  }

  static String _getRandomStreetName() {
    const names = ['Main', 'Oak', 'Pine', 'Maple', 'Cedar', 'Elm', 'Washington', 'Lake', 'Hill', 'Park'];
    return names[_random.nextInt(names.length)];
  }
  
  static List<T> _getRandomSublist<T>(List<T> list, int count) {
    if (list.isEmpty || count <= 0) return [];
    List<T> shuffled = List<T>.from(list)..shuffle(_random);
    return shuffled.take(min(count, shuffled.length)).toList();
  }

  static String _getServiceTitle(String category, int index) {
    const adjectives = ['Expert', 'Reliable', 'Affordable', 'Quick', 'Professional', 'Complete', 'Custom', 'Local'];
    const nouns = ['Service', 'Solutions', 'Help', 'Assistance', 'Work', 'Installation', 'Repair', 'Care'];
    String adj = adjectives[_random.nextInt(adjectives.length)];
    String noun = nouns[_random.nextInt(nouns.length)];
    return '$adj $category $noun #${index + _random.nextInt(100)}';
  }

  static String _getServiceDescription(String title, String providerName) {
    const phrases = [
      'Offering top-notch services for your needs.',
      'Get the best quality work at competitive prices.',
      'Experienced professionals ready to assist you.',
      'Your satisfaction is our priority.',
      'We specialize in providing excellent results.'
    ];
    return '${phrases[_random.nextInt(phrases.length)]} This service, "$title", is provided by $providerName. We cover all aspects of the job, ensuring a smooth and efficient process.';
  }

  static String _getSampleAvailability() {
    const days = ['Mon-Fri', 'Weekends', '7 days a week', 'By Appointment'];
    const times = ['9 AM - 5 PM', 'Flexible Hours', '24/7 On Call', 'Evenings Available'];
    return '${days[_random.nextInt(days.length)]}, ${times[_random.nextInt(times.length)]}';
  }

  // Optional: A method to clear the seeded data (for testing)
  // static Future<void> clearSeededData() async {
  //   print('Clearing seeded data...');
  //   try {
  //     await _firestore.collection('users').doc('sample_provider_uid_123').delete();
  //     await _firestore.collection('services').doc('auto_generated_id_for_now_1').delete();
  //     await _firestore.collection('services').doc('auto_generated_id_for_now_2').delete();
  //     print('Finished clearing seeded data.');
  //   } catch (e) {
  //     print('Error clearing data: $e');
  //   }
  // }
} 