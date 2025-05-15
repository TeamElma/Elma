import 'package:flutter/material.dart';
import 'package:elma/models/service_model.dart'; // Import ServiceModel

class ServiceProviderPage extends StatefulWidget {
  // Removed const since we might receive arguments
  ServiceProviderPage({Key? key}) : super(key: key);

  @override
  State<ServiceProviderPage> createState() => _ServiceProviderPageState();
}

class _ServiceProviderPageState extends State<ServiceProviderPage> {
  bool _isFavorite = false;
  // These will be overridden by service data if available
  // double _rating = 4.95; 
  // int _reviews = 22;
  // final int _monthsWorking = 10; // This might not be in ServiceModel

  @override
  Widget build(BuildContext context) {
    // Retrieve the ServiceModel passed as an argument
    final ServiceModel? service = ModalRoute.of(context)?.settings.arguments as ServiceModel?;

    if (service == null) {
      // Handle case where service is not passed, though this shouldn't happen with correct navigation
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Service details not found.")),
      );
    }

    // Use service data, with fallbacks for safety
    final String providerName = service.providerName ?? 'Service Provider';
    final String serviceTitle = service.title;
    final String serviceCategory = service.category ?? 'Uncategorized';
    final String mainImageUrl = (service.imageUrls != null && service.imageUrls!.isNotEmpty)
        ? service.imageUrls![0]
        : 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=2069&auto=format&fit=crop'; // Fallback image
    final String providerPhoto = service.providerPhotoUrl ?? 'https://i.pravatar.cc/150?img=8'; // Fallback avatar
    final double averageRating = service.averageRating ?? 0.0;
    final int totalReviews = service.totalReviews ?? 0; // Corrected from totalRatings to totalReviews
    final String locationAddress = service.serviceLocation?.addressString ?? 'Location not available'; // Corrected to serviceLocation.addressString
    final String serviceDescription = service.description ?? 'No description available.';
    // Price for the bottom bar
    final String priceDisplay = service.priceInfo != null
        ? '${service.priceInfo!.amount.toStringAsFixed(2)} ${service.priceInfo!.currency} ${service.priceInfo!.basis}'
        : 'Price N/A';
    
    final bool isProviderVerified = service.providerIsVerified ?? false; // Assuming this field might be added to ServiceModel from UserModel
    final int experienceYears = (service.providerExperienceMonths ?? 0) ~/ 12;
    final int imageCount = service.imageUrls?.length ?? 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 250, // Allow app bar to expand
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mainImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover), // Placeholder on error
                  ),
                  if (imageCount > 1)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '1 / $imageCount', // Simple counter, real gallery is more complex
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: const BackButton(color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement share functionality
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share not implemented yet.')),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                        // TODO: Implement favorite/wishlist backend integration
                      });
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isFavorite ? 'Added to favorites.' : 'Removed from favorites.')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider Info Section (replaces old Stack and Image.network)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceTitle, // Dynamic service title
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Service by $providerName • $serviceCategory', // Dynamic provider and category
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 18, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${averageRating.toStringAsFixed(1)} ($totalReviews reviews)', // Dynamic rating & reviews
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          // const Text(' · ', style: TextStyle(fontSize: 14)),
                          // const Text( // Superworker might be a derived status, not in base model
                          //   'Superworker',
                          //   style: TextStyle(fontSize: 14),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (locationAddress != 'Location not available') // Show location if available
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                locationAddress, // Dynamic location
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      const Divider(height: 24, thickness: 1, indent: 0, endIndent: 0),

                      // Key Highlights Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          spacing: 16.0, // Horizontal spacing between items
                          runSpacing: 12.0, // Vertical spacing between lines
                          children: [
                            if (isProviderVerified)
                              _buildHighlightItem(Icons.verified_user_outlined, 'Verified Provider', context),
                            if (experienceYears > 0)
                              _buildHighlightItem(Icons.military_tech_outlined, '$experienceYears+ years experience', context),
                            _buildHighlightItem(Icons.category_outlined, serviceCategory, context),
                            // Add more highlights as needed based on data
                          ],
                        ),
                      ),

                      const Divider(height: 24, thickness: 1, indent: 0, endIndent: 0),
                    ],
                  ),
                ),

                // About the service / Description
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'About this service',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Provider avatar and name - small section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(providerPhoto),
                             onBackgroundImageError: (_, __) => Icon(Icons.person, size: 20), // Fallback icon
                          ),
                          const SizedBox(width: 8),
                           Text(
                            providerName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Add Message Host Button here
                      ElevatedButton.icon(
                        icon: const Icon(Icons.message_outlined),
                        label: Text('Message $providerName'),
                        onPressed: () {
                          // TODO: Pass provider details to Inbox/Chat screen for specific chat
                          Navigator.pushNamed(context, '/inbox');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        serviceDescription, // Dynamic service description
                        style: TextStyle(fontSize: 15, color: Colors.grey[800], height: 1.5),
                      ),
                      const SizedBox(height: 16),

                      // Display Service Availability
                      if (service.availability != null && service.availability!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined, size: 18, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                service.availability!,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Display Service Tags
                      if (service.tags != null && service.tags!.isNotEmpty) ...[
                        Text(
                          'Tags',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: service.tags!
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: Colors.grey[200],
                                    labelStyle: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      
                      const Divider(height: 32),
                    ],
                  ),
                ),
                
                // TODO: Re-add Reviews Section if data is available for it
                // For now, it's commented out as it's not directly in ServiceModel for this example
                // _buildReviewsSection(context),

                // TODO: Re-add "Where you'll be" (Map section) if location data is robust
                // _buildLocationSection(context, locationAddress),

                const SizedBox(height: 80), // Space for the bottom bar
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar for Actions
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  priceDisplay, // Dynamic price
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Text( // If you have date selection later
                //   'Aug 15 - 20',
                //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                // ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to checkout or booking screen
                Navigator.pushNamed(context, '/checkout', arguments: service);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Checkout/Reserve not implemented yet.')),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reserve'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widgets (can be kept if useful, or removed if layout is simpler)
  // Make sure these are updated if used, or remove them.
  // For now, I'll comment them out as the main structure is changing.

  // Widget _buildServiceCategory({required IconData icon, required String title}) { ... }
  // Widget _buildServiceFeature({required IconData icon, required String title, required String description}) { ... }
  // Widget _buildReviewItem(...) { ... }
  // Widget _buildLocationSection(...) { ... }
  // Widget _buildReviewsSection(...) { ... }

  // Helper for Key Highlights
  Widget _buildHighlightItem(IconData icon, String label, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
