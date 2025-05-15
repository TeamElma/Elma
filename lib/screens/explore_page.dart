// lib/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added for state management
import 'package:elma/models/service_model.dart'; // Added for ServiceModel
import 'booking_search_screen.dart';

/// --- Data Models ---

/// Represents a category for filtering listings.
class CategoryItem {
  final IconData icon;
  final String name;
  CategoryItem({required this.icon, required this.name});
}

/// --- Explore Screen ---

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCategoryIndex = 0;
  int _currentBottomNavIndex = 0;

  final List<CategoryItem> _categories = [
    CategoryItem(icon: Icons.apps, name: 'All'),
    CategoryItem(icon: Icons.handyman_outlined, name: 'Maintenance'),
    CategoryItem(icon: Icons.move_up_outlined, name: 'Moving'),
    CategoryItem(icon: Icons.build_outlined, name: 'Repairs'),
    CategoryItem(icon: Icons.cleaning_services_outlined, name: 'Cleaning'),
    CategoryItem(icon: Icons.nightlife_outlined, name: 'Lifestyle'),
    CategoryItem(icon: Icons.design_services_outlined, name: 'Design'),
    CategoryItem(icon: Icons.plumbing_outlined, name: 'Plumbing'),
    // TODO: Consider populating categories dynamically or aligning with ServiceModel.category
  ];

  void _onCategorySelected(int i) =>
      setState(() => _selectedCategoryIndex = i);

  void _onBottomNavTap(int idx) {
    if (idx == 0) {
      // Clear out everything and show Explore as the only route
      Navigator.pushNamedAndRemoveUntil(context, '/explore', (r) => false);
      return;
    }
    if (idx == 3) {
      Navigator.pushNamed(context, '/inbox');
      return;
    }
    if (idx == 4) {
      Navigator.pushNamed(context, '/profile');
      return;
    }
    setState(() => _currentBottomNavIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    // Consume the list of services from the provider, now nullable
    final allServices = context.watch<List<ServiceModel>?>();

    Widget bodyWidget;

    if (allServices == null) {
      // Loading state
      bodyWidget = const Center(child: CircularProgressIndicator());
    } else if (allServices.isEmpty) {
      // No services found OR error occurred (since catchError in provider returns [])
      bodyWidget = const Center(child: Text('No services found or error loading services.'));
    } else {
      // Data available, implement filtering
      List<ServiceModel> filteredServices;
      if (_selectedCategoryIndex == 0) { // "All" category
        filteredServices = allServices;
      } else {
        // Adjust index because "All" was added at the beginning of _categories
        final selectedCategoryName = _categories[_selectedCategoryIndex].name;
        filteredServices = allServices
            .where((service) => service.category == selectedCategoryName)
            .toList();
      }
      
      if (filteredServices.isEmpty) {
        bodyWidget = Center(child: Text('No services found in the selected category: ${_categories[_selectedCategoryIndex].name}.'));
      } else {
        bodyWidget = _ListingList(services: filteredServices);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        // Tappable "search bar"
        title: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.centerLeft,
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text('How can we help?', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _CategoryTabs(
            categories: _categories,
            selectedIndex: _selectedCategoryIndex,
            onCategorySelected: _onCategorySelected,
          ),
        ),
      ),
      body: bodyWidget,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Map view not implemented'))),
        label: const Text('Map'),
        icon: const Icon(Icons.map_outlined),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.room_service_outlined), label: 'Services'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined), label: 'Inbox'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

/// --- Category Tabs Widget ---
class _CategoryTabs extends StatelessWidget {
  final List<CategoryItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const _CategoryTabs({
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          final c = categories[i];
          final sel = i == selectedIndex;
          return GestureDetector(
            onTap: () => onCategorySelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(c.icon,
                      size: 22,
                      color: sel
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 4),
                  Text(
                    c.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: sel
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (sel)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 2,
                      width: 30,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  else
                    const SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// --- Listing List & Card Widgets (Modified for ServiceModel) ---

class _ListingList extends StatelessWidget {
  final List<ServiceModel> services;

  const _ListingList({
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(child: Text('No services to display.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (ctx, i) {
        final service = services[i];
        return _ListingCard(
          service: service,
        );
      },
    );
  }
}

class _ListingCard extends StatelessWidget {
  final ServiceModel service;

  const _ListingCard({
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: service);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: (service.imageUrls != null && service.imageUrls!.isNotEmpty)
                      ? NetworkImage(service.imageUrls![0])
                      : const AssetImage('assets/images/placeholder_image.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(service.providerPhotoUrl ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          service.providerName ?? 'Service Provider',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.category ?? 'Uncategorized',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        service.averageRating?.toStringAsFixed(1) ?? 'N/A',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${service.priceInfo?.amount ?? 'N/A'} ${service.priceInfo?.currency ?? ''} ${service.priceInfo?.basis ?? ''}'.trim(),
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
