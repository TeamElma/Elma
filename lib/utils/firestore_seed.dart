import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elma/models/user_model.dart';
import 'package:elma/models/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For current user if needed for createdBy fields

class FirestoreSeed {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> seedInitialData() async {
    print('Starting to seed initial data...');

    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      print('SEEDER: No authenticated user. Skipping.');
      return;
    }
    String providerUid = currentUser.uid;
    print('SEEDER: Current user UID for seeding: $providerUid, Email: ${currentUser.email}');

    String userEmail = currentUser.email ?? 'provider@example.com'; // Use logged-in user's email or default
    String userDisplayName = currentUser.displayName ?? 'Current User (Provider)'; // Use logged-in user's name or default
    String? userPhotoUrl = currentUser.photoURL; // Use logged-in user's photo or default

    try {
      // 1. Create or Update the currently logged-in user as a Service Provider
      print('Attempting to seed/update provider data for UID: $providerUid');

      UserModel serviceProvider = UserModel(
        userId: providerUid,
        email: userEmail,
        displayName: userDisplayName,
        isServiceProvider: true,
        photoUrl: userPhotoUrl ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
        aboutMe: 'This is a sample provider profile for the logged-in user.',
        providerName: '${userDisplayName}\'s Services',
        providerBio: 'Services provided by the currently authenticated user.',
        specialties: ['General', 'Tasks', 'Services'],
        providerLocation: LocationModel(
          addressString: '123 App St, Flutter City',
          city: 'Techville',
          geopoint: const GeoPoint(40.7128, -74.0060), // Example coordinates
        ),
        experienceMonths: 12,
        overallRating: 0.0, // Initial rating
        totalServiceReviews: 0, // Initial reviews
        isVerified: false, // Or true if you want them verified by default
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      // Use .set with merge:true to avoid overwriting existing user data if they only become a provider
      await _firestore.collection('users').doc(providerUid).set(serviceProvider.toMap(), SetOptions(merge: true));
      print('SEEDER: User document for $providerUid seeded/updated.');

      // 2. Create Sample Services for this Provider
      // Check if services already exist for this provider to avoid duplicates on every run
      final servicesCollection = _firestore.collection('services');
      print('SEEDER: About to query services for providerId: $providerUid. Current auth UID: ${_auth.currentUser?.uid}'); // Check again right before query
      
      final existingServicesSnapshot = await servicesCollection.where('providerId', isEqualTo: providerUid).limit(1).get();
      print('SEEDER: Query for existing services completed. Found: ${existingServicesSnapshot.docs.length} docs.');

      if (existingServicesSnapshot.docs.isNotEmpty) {
        print('Services for provider $providerUid already exist. Skipping service seeding.');
      } else {
        print('Seeding new services for provider $providerUid');
        ServiceModel service1 = ServiceModel(
          serviceId: 'seeded_service_1_$providerUid', // Ensure unique ID for this provider
          providerId: providerUid,
          providerName: serviceProvider.providerName,
          providerPhotoUrl: serviceProvider.photoUrl,
          title: 'Sample Task A',
          description: 'Description for Sample Task A provided by ${serviceProvider.displayName}.',
          category: 'General',
          priceInfo: PriceInfoModel(amount: 50, currency: 'USD', basis: 'fixed'),
          imageUrls: [
            'https://images.unsplash.com/photo-1556740714-a8395b3bf301?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1024&q=60'
          ],
          serviceLocation: ServiceLocationModel(
              addressString: 'Remote or On-site depending on task',
              city: 'Techville'
          ),
          availability: 'Flexible',
          averageRating: 0.0,
          totalReviews: 0,
          tags: ['sample', 'task', 'general'],
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          isActive: true,
        );

        ServiceModel service2 = ServiceModel(
          serviceId: 'seeded_service_2_$providerUid', // Ensure unique ID for this provider
          providerId: providerUid,
          providerName: serviceProvider.providerName,
          providerPhotoUrl: serviceProvider.photoUrl,
          title: 'Consulting Session (Example)',
          description: 'One hour consulting session example by ${serviceProvider.displayName}.',
          category: 'Consulting',
          priceInfo: PriceInfoModel(amount: 100, currency: 'USD', basis: 'hourly'),
          imageUrls: [
            'https://images.unsplash.com/photo-1542744095-291d1f67b221?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1024&q=60'
          ],
          availability: 'By Appointment',
          averageRating: 0.0,
          totalReviews: 0,
          tags: ['consulting', 'example', 'hourly'],
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          isActive: true,
        );
        
        DocumentReference service1Ref = servicesCollection.doc(service1.serviceId);
        print('SEEDER DEBUG: Attempting to create service1. Auth UID: ${_auth.currentUser?.uid}, Service providerId: ${service1.providerId}, Service title: ${service1.title}');
        await service1Ref.set(service1.toMap());
        print('Seeded service: ${service1.title}');

        DocumentReference service2Ref = servicesCollection.doc(service2.serviceId);
        print('SEEDER DEBUG: Attempting to create service2. Auth UID: ${_auth.currentUser?.uid}, Service providerId: ${service2.providerId}, Service title: ${service2.title}');
        await service2Ref.set(service2.toMap());
        print('Seeded service: ${service2.title}');
      }
      print('Finished seeding initial data successfully!');
    } catch (e, s) {
      print('Error seeding data: $e');
      print('Stack trace: $s');
    }
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