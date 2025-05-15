import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elma/models/service_model.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'services';

  // CREATE
  Future<ServiceModel> createService(ServiceModel service) async {
    try {
      // If serviceId is not provided or is empty, Firestore will generate one
      final useProvidedId = service.serviceId.isNotEmpty && service.serviceId != 'auto_generated_id_for_now_1' && service.serviceId != 'auto_generated_id_for_now_2';
      
      DocumentReference docRef;
      
      if (useProvidedId) {
        // Use the provided ID
        docRef = _firestore.collection(_collection).doc(service.serviceId);
        await docRef.set(service.toMap());
      } else {
        // Let Firestore generate an ID
        docRef = await _firestore.collection(_collection).add(service.toMap());
      }
      
      // Fetch the newly created document to return the complete model
      DocumentSnapshot snapshot = await docRef.get();
      return ServiceModel.fromDocument(snapshot);
    } catch (e) {
      print('Error creating service: $e');
      rethrow;
    }
  }

  // READ - Get a single service by ID
  Future<ServiceModel?> getService(String serviceId) async {
    try {
      DocumentSnapshot snapshot = 
          await _firestore.collection(_collection).doc(serviceId).get();
      
      if (snapshot.exists) {
        return ServiceModel.fromDocument(snapshot);
      }
      return null;
    } catch (e) {
      print('Error getting service: $e');
      rethrow;
    }
  }

  // READ - Get all services
  Future<List<ServiceModel>> getAllServices() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      
      return snapshot.docs
          .map((doc) => ServiceModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting all services: $e');
      rethrow;
    }
  }

  // READ - Get services by provider ID
  Future<List<ServiceModel>> getServicesByProvider(String providerId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('providerId', isEqualTo: providerId)
          .get();
      
      return snapshot.docs
          .map((doc) => ServiceModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting services by provider: $e');
      rethrow;
    }
  }

  // READ - Get services by category
  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();
      
      return snapshot.docs
          .map((doc) => ServiceModel.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error getting services by category: $e');
      rethrow;
    }
  }

  // UPDATE
  Future<ServiceModel> updateService(ServiceModel service) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(service.serviceId)
          .update(service.toMap());
      
      // Fetch the updated document to return
      DocumentSnapshot snapshot = 
          await _firestore.collection(_collection).doc(service.serviceId).get();
      
      // Use doc.id and doc.data()! for fromDocument
      return ServiceModel.fromDocument(snapshot); 
    } catch (e) {
      print('Error updating service: $e');
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection(_collection).doc(serviceId).delete();
    } catch (e) {
      print('Error deleting service: $e');
      rethrow;
    }
  }

  // Stream for a single service document
  Stream<ServiceModel> getServiceStream(String serviceId) {
    return _firestore.collection(_collection).doc(serviceId)
        .snapshots()
        // Use doc.id and doc.data()! for fromDocument
        .map((doc) => ServiceModel.fromDocument(doc)); 
  }

  // READ - Get a stream of all services
  Stream<List<ServiceModel>> getServicesStream() {
    return _firestore.collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            // Use doc.id and doc.data()! for fromDocument
            .map((doc) => ServiceModel.fromDocument(doc)) 
            .toList());
  }

  // READ - Get a stream of services by a specific provider
  Stream<List<ServiceModel>> getServicesByProviderStream(String providerId) {
    return _firestore.collection(_collection)
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            // Use doc.id and doc.data()! for fromDocument
            .map((doc) => ServiceModel.fromDocument(doc)) 
            .toList());
  }
} 