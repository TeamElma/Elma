import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elma/models/user_model.dart';
import 'package:elma/models/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For current user if needed for createdBy fields

class FirestoreSeed {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> seedInitialData() async {
    print('Starting to seed initial data...');
    try {
      // 1. Create a sample Service Provider User
      // For simplicity, we won't create a Firebase Auth user here,
      // but assume a provider's UID. In a real app, this user would already exist via Auth.
      String providerUid = 'sample_provider_uid_123';

      UserModel serviceProvider = UserModel(
        userId: providerUid,
        email: 'provider@example.com',
        displayName: 'Ahmet Yılmaz',
        isServiceProvider: true,
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
        aboutMe: 'Experienced handyman serving the Istanbul area. ',
        providerName: 'Ahmet\'s Reliable Handyman Services',
        providerBio: 'Over 10 years of experience in home repairs, electrical work, and plumbing. Customer satisfaction guaranteed!',
        specialties: ['Plumbing', 'Electrical', 'Home Repair'],
        providerLocation: LocationModel(
          addressString: '123 Main St, Beşiktaş',
          city: 'Istanbul',
          geopoint: const GeoPoint(41.0444, 29.0027), // Example coordinates for Beşiktaş
        ),
        experienceMonths: 120,
        overallRating: 4.8,
        totalServiceReviews: 75,
        isVerified: true,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await _firestore.collection('users').doc(providerUid).set(serviceProvider.toMap());
      print('Seeded sample provider: ${serviceProvider.displayName}');

      // 2. Create Sample Services for this Provider
      ServiceModel service1 = ServiceModel(
        serviceId: 'auto_generated_id_for_now_1', // Firestore can auto-generate if we .add()
        providerId: providerUid,
        providerName: serviceProvider.providerName,
        providerPhotoUrl: serviceProvider.photoUrl,
        title: 'Leaky Faucet Repair',
        description: 'Quick and efficient repair of all types of leaky faucets. Stop the drip and save water!',
        category: 'Plumbing',
        priceInfo: PriceInfoModel(amount: 150, currency: 'TRY', basis: 'fixed'),
        imageUrls: [
          'https://images.unsplash.com/photo-1600585152220-014138855572?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGx1bWJpbmd8ZW58MHx8MHx8fDA%3D&w=1000&q=80'
        ],
        serviceLocation: ServiceLocationModel(
            addressString: 'Servicing all Istanbul',
            city: 'Istanbul'
        ),
        availability: 'Mon-Sat, 9am-6pm',
        averageRating: 4.9,
        totalReviews: 30,
        tags: ['faucet', 'leak', 'plumbing', 'repair'],
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        isActive: true,
      );

      ServiceModel service2 = ServiceModel(
        serviceId: 'auto_generated_id_for_now_2',
        providerId: providerUid,
        providerName: serviceProvider.providerName,
        providerPhotoUrl: serviceProvider.photoUrl,
        title: 'Electrical Outlet Installation',
        description: 'Safe installation of new electrical outlets or replacement of old ones. All work up to code.',
        category: 'Electrical',
        priceInfo: PriceInfoModel(amount: 250, currency: 'TRY', basis: 'per outlet'),
        imageUrls: [
          'https://images.unsplash.com/photo-1617953141905-c17e5197f19c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZWxlY3RyaWNhbCUyMG91dGxldHxlbnwwfHx8fHx8MA%3D%3D&w=1000&q=80'
        ],
        availability: 'Mon-Fri, 10am-5pm',
        averageRating: 4.7,
        totalReviews: 25,
        tags: ['outlet', 'electrical', 'installation', 'wiring'],
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        isActive: true,
      );
      
      // Add services. Using .doc(serviceId).set() for now as we defined serviceId in the model.
      // If serviceId were not in the model and we wanted Firestore to generate it, we would use .add().
      DocumentReference service1Ref = _firestore.collection('services').doc(service1.serviceId);
      await service1Ref.set(service1.toMap());
      print('Seeded service: ${service1.title}');

      DocumentReference service2Ref = _firestore.collection('services').doc(service2.serviceId);
      await service2Ref.set(service2.toMap());
      print('Seeded service: ${service2.title}');

      print('Finished seeding initial data successfully!');
    } catch (e, s) {
      print('Error seeding data: $e');
      print('Stack trace: $s');
      // rethrow; // Optionally rethrow to make it crash and be more visible
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