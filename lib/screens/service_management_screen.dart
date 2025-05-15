import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elma/models/service_model.dart';
import 'package:elma/repositories/service_repository.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({Key? key}) : super(key: key);

  @override
  _ServiceManagementScreenState createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final ServiceRepository _serviceRepository = ServiceRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // For simplicity, using text input

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Create new service
  void _createService(ServiceModel service) async {
    print('Attempting to create service with providerId: ${service.providerId}');
    print('Current authenticated user UID: ${_auth.currentUser?.uid}');
    try {
      await _serviceRepository.createService(service);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service created successfully!')),
      );
    } catch (e) {
      print('Error creating service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create service: $e')),
      );
    }
  }

  // Update existing service
  void _updateService(ServiceModel service) async {
    print('Attempting to update service with ID: ${service.serviceId}');
    print('Service providerId: ${service.providerId}');
    print('Current authenticated user UID: ${_auth.currentUser?.uid}');
    try {
      await _serviceRepository.updateService(service);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service updated successfully!')),
      );
    } catch (e) {
      print('Error updating service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update service: $e')),
      );
    }
  }

  // Delete service
  void _deleteService(String serviceId, String providerId) async {
    print('Attempting to delete service with ID: $serviceId');
    print('Service providerId: $providerId');
    print('Current authenticated user UID: ${_auth.currentUser?.uid}');
    try {
      await _serviceRepository.deleteService(serviceId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete service: $e')),
      );
    }
  }

  void _showAddOrEditServiceDialog({ServiceModel? serviceToEdit}) {
    final bool isEditing = serviceToEdit != null;
    if (isEditing) {
      _nameController.text = serviceToEdit.title;
      _descriptionController.text = serviceToEdit.description ?? '';
      _categoryController.text = serviceToEdit.category;
      _priceController.text = serviceToEdit.priceInfo?.amount.toString() ?? '';
      _imageUrlController.text = (serviceToEdit.imageUrls?.isNotEmpty ?? false) ? serviceToEdit.imageUrls!.first : '';
    } else {
      _nameController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _priceController.clear();
      _imageUrlController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Service' : 'Add New Service'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Service Name')),
                TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL (Optional)')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(isEditing ? 'Update' : 'Add'),
              onPressed: () {
                final String name = _nameController.text.trim();
                final String description = _descriptionController.text.trim();
                final String category = _categoryController.text.trim();
                final double? price = double.tryParse(_priceController.text.trim());
                final String imageUrl = _imageUrlController.text.trim();
                final String currentUserId = _auth.currentUser?.uid ?? '';

                if (name.isNotEmpty && description.isNotEmpty && category.isNotEmpty && price != null && currentUserId.isNotEmpty) {
                  final service = ServiceModel(
                    serviceId: isEditing ? serviceToEdit.serviceId : '', // Firestore generates ID if empty
                    title: name,
                    description: description,
                    category: category,
                    providerId: isEditing ? serviceToEdit.providerId : currentUserId, // Keep original providerId on edit
                    priceInfo: PriceInfoModel(amount: price, currency: 'USD', basis: 'Fixed'),
                    availability: 'Available', // Simplified
                    serviceLocation: ServiceLocationModel(addressString: ''), // Removed type, added placeholder
                    imageUrls: imageUrl.isNotEmpty ? [imageUrl] : [],
                    averageRating: isEditing ? serviceToEdit.averageRating : 0.0,
                    totalReviews: isEditing ? serviceToEdit.totalReviews : 0,
                    tags: category.split(',').map((e) => e.trim()).toList(), // Simplified
                    createdAt: isEditing ? serviceToEdit.createdAt : Timestamp.now(),
                    updatedAt: Timestamp.now(),
                  );
                  if (isEditing) {
                    _updateService(service);
                  } else {
                    _createService(service);
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields and ensure you are logged in.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _auth.currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Your Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddOrEditServiceDialog(),
          ),
        ],
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: _serviceRepository.getServicesStream(), // Assuming you have a method that streams all services
        // Or, if you only want to show services by the current provider:
        // stream: _serviceRepository.getServicesByProviderStream(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services found. Add one!'));
          }

          final services = snapshot.data!;
          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final bool canEditOrDelete = service.providerId == currentUserId;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: (service.imageUrls?.isNotEmpty ?? false)
                      ? Image.network(service.imageUrls!.first, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, o, s) => Icon(Icons.broken_image))
                      : const Icon(Icons.design_services, size: 40),
                  title: Text(service.title),
                  subtitle: Text('${service.category} - \$${service.priceInfo?.amount.toStringAsFixed(2) ?? 'N/A'}\\nProvider: ${service.providerId == currentUserId ? "You" : service.providerId}'),
                  isThreeLine: true,
                  trailing: canEditOrDelete
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddOrEditServiceDialog(serviceToEdit: service),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Confirmation Dialog for delete
                                showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: Text('Are you sure you want to delete "${service.title}"?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () => Navigator.of(ctx).pop(),
                                        ),
                                        TextButton(
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            _deleteService(service.serviceId, service.providerId);
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      : null, // No edit/delete options if not the owner
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Widget for displaying a service in the list
class ServiceListItem extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  const ServiceListItem({
    Key? key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(service.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.category),
            if (service.description != null && service.description!.isNotEmpty)
              Text(
                service.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (service.priceInfo != null)
              Text(
                '${service.priceInfo!.amount} ${service.priceInfo!.currency} (${service.priceInfo!.basis})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
} 