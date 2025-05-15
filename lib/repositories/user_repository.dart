import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elma/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'users';

  // Get current user ID from Firebase Auth
  String? get currentUserId => _auth.currentUser?.uid;

  // CREATE or UPDATE user profile
  Future<UserModel> createOrUpdateUser(UserModel user) async {
    try {
      // Check if this is a new user or updating an existing one
      DocumentReference docRef = _firestore.collection(_collection).doc(user.userId);
      
      // First check if document exists
      DocumentSnapshot docSnap = await docRef.get();
      
      if (docSnap.exists) {
        // Update existing user
        await docRef.update(user.toMap());
      } else {
        // Create new user
        await docRef.set(user.toMap());
      }
      
      // Get the updated document
      DocumentSnapshot updatedSnap = await docRef.get();
      return UserModel.fromDocument(updatedSnap);
    } catch (e) {
      print('Error creating/updating user: $e');
      rethrow;
    }
  }

  // READ - Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(userId).get();
      
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  // READ - Get current authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserId == null) return null;
      
      return await getUser(currentUserId!);
    } catch (e) {
      print('Error getting current user: $e');
      rethrow;
    }
  }

  // READ - Get all service providers
  Future<List<UserModel>> getAllServiceProviders() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isServiceProvider', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting service providers: $e');
      rethrow;
    }
  }

  // READ - Get service providers by specialty
  Future<List<UserModel>> getServiceProvidersBySpecialty(String specialty) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isServiceProvider', isEqualTo: true)
          .where('specialties', arrayContains: specialty)
          .get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting service providers by specialty: $e');
      rethrow;
    }
  }

  // UPDATE a user
  Future<UserModel> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.userId)
          .update(user.toMap());
      
      DocumentSnapshot docSnap = await _firestore.collection(_collection).doc(user.userId).get();
      return UserModel.fromDocument(docSnap);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // UPDATE user's FCM token
  Future<void> updateFcmToken(String userId, String token) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .update({'fcmToken': token});
    } catch (e) {
      print('Error updating FCM token: $e');
      rethrow;
    }
  }

  // DELETE a user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // REAL-TIME STREAM - Current user
  Stream<UserModel?> currentUserStream() {
    if (currentUserId == null) {
      // Return an empty stream if no user is authenticated
      return Stream.value(null);
    }
    
    return _firestore
        .collection(_collection)
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.exists 
            ? UserModel.fromDocument(snapshot) 
            : null);
  }

  // REAL-TIME STREAM - Service providers
  Stream<List<UserModel>> serviceProvidersStream() {
    return _firestore
        .collection(_collection)
        .where('isServiceProvider', isEqualTo: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList());
  }
} 