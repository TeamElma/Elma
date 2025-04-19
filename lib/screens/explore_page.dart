// lib/screens/explore_screen.dart
import 'package:flutter/material.dart';
import 'booking_search_screen.dart';

/// --- Data Models ---

/// Represents a category for filtering listings.
class CategoryItem {
  final IconData icon;
  final String name;
  CategoryItem({required this.icon, required this.name});
}

/// Represents a single listing in the explore view.
class ListingItem {
  final List<String> imageUrls;
  final String profileImageUrl;
  final String title;
  final String distance;
  final String category;
  final double rating;
  final String price;
  bool isFavorite;
  int currentImageIndex;

  ListingItem({
    required this.imageUrls,
    required this.profileImageUrl,
    required this.title,
    required this.distance,
    required this.category,
    required this.rating,
    required this.price,
    this.isFavorite = false,
    this.currentImageIndex = 0,
  });
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
    CategoryItem(icon: Icons.handyman_outlined, name: 'Maintenance'),
    CategoryItem(icon: Icons.move_up_outlined, name: 'Moving'),
    CategoryItem(icon: Icons.build_outlined, name: 'Repairs'),
    CategoryItem(icon: Icons.cleaning_services_outlined, name: 'Cleaning'),
    CategoryItem(icon: Icons.nightlife_outlined, name: 'Lifestyle'),
    CategoryItem(icon: Icons.design_services_outlined, name: 'Design'),
    CategoryItem(icon: Icons.plumbing_outlined, name: 'Plumbing'),
  ];

  final List<ListingItem> _listings = [
    ListingItem(
      imageUrls: [
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_2.jpg',
        'https://www.gstatic.com/flutter-onestack-prototype/genui/example_3.jpg',
      ],
      profileImageUrl:
      'https://www.gstatic.com/flutter-onestack-prototype/genui/example_host.jpg',
      title: 'Ali Ahmet',
      distance: '34 miles away',
      category: 'Home Renovation',
      rating: 4.96,
      price: '\$60 per hour',
    ),
  ];

  void _onCategorySelected(int i) =>
      setState(() => _selectedCategoryIndex = i);

  void _onFavoriteToggle(int idx) =>
      setState(() => _listings[idx].isFavorite = !_listings[idx].isFavorite);

  void _onImageChanged(int li, int ii) {
    if (_listings[li].currentImageIndex != ii) {
      setState(() => _listings[li].currentImageIndex = ii);
    }
  }

  /// Now handles:
  ///  • idx==0 → reset the entire stack to just Explore
  ///  • idx==3 → push Inbox on top
  ///  • idx==4 → push Profile on top
  ///  • otherwise just switches the highlighted tab
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
    final displayed = _listings; // no filtering for now

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
      body: _ListingList(
        listings: displayed,
        onFavoriteToggle: _onFavoriteToggle,
        onImageChanged: _onImageChanged,
      ),
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
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 4),
                  Text(
                    c.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: sel
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (sel)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 2,
                      width: 30,
                      color: theme.colorScheme.primary,
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

/// --- Listings List & Card ---
class _ListingList extends StatelessWidget {
  final List<ListingItem> listings;
  final ValueChanged<int> onFavoriteToggle;
  final void Function(int, int) onImageChanged;

  const _ListingList({
    required this.listings,
    required this.onFavoriteToggle,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding:
      const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
      itemCount: listings.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: _ListingCard(
          listing: listings[i],
          listingIndex: i,
          onFavoriteToggle: () => onFavoriteToggle(i),
          onImageChanged: (ii) => onImageChanged(i, ii),
        ),
      ),
    );
  }
}

class _ListingCard extends StatefulWidget {
  final ListingItem listing;
  final int listingIndex;
  final VoidCallback onFavoriteToggle;
  final ValueChanged<int> onImageChanged;

  const _ListingCard({
    required this.listing,
    required this.listingIndex,
    required this.onFavoriteToggle,
    required this.onImageChanged,
  });

  @override
  State<_ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<_ListingCard> {
  late final PageController _pageController;
  bool _profileImageLoadFailed = false;

  @override
  void initState() {
    super.initState();
    _pageController =
    PageController(initialPage: widget.listing.currentImageIndex)
      ..addListener(() {
        final idx = _pageController.page
            ?.round() ??
            widget.listing.currentImageIndex;
        if (idx != widget.listing.currentImageIndex) {
          widget.onImageChanged(idx);
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width - 32;
    final canLoad =
        !_profileImageLoadFailed && l.profileImageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/details'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image carousel
          Stack(
            children: [
              Container(
                height: width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: l.imageUrls.length,
                    itemBuilder: (ctx, idx) => Image.network(
                      l.imageUrls[idx],
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, ch, prog) {
                        if (prog == null) return ch;
                        return Center(
                          child: CircularProgressIndicator(
                            value: prog.expectedTotalBytes != null
                                ? prog.cumulativeBytesLoaded /
                                prog.expectedTotalBytes!
                                : null,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                      errorBuilder: (ctx, err, st) => const Center(
                        child: Icon(Icons.broken_image,
                            size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              // Favorite icon
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: Icon(
                    l.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: l.isFavorite
                        ? theme.colorScheme.primary
                        : Colors.white,
                  ),
                  onPressed: widget.onFavoriteToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              // Profile avatar
              Positioned(
                bottom: 12,
                left: 12,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage:
                    canLoad ? NetworkImage(l.profileImageUrl) : null,
                    onBackgroundImageError: canLoad
                        ? (_, __) =>
                        setState(() => _profileImageLoadFailed = true)
                        : null,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    child: !canLoad
                        ? Icon(Icons.person_outline,
                        color:
                        theme.colorScheme.onSurfaceVariant,
                        size: 28)
                        : null,
                  ),
                ),
              ),
              if (l.imageUrls.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children:
                    List.generate(l.imageUrls.length, (i) {
                      final cur = l.currentImageIndex;
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == cur
                              ? Colors.white
                              : Colors.white
                              .withAlpha(128),
                          border: Border.all(
                              color: Colors.black26,
                              width: 0.5),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Text details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(l.title,
                        style:
                        theme.textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(l.distance,
                        style: theme
                            .textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Text(l.category,
                        style: theme
                            .textTheme.bodyMedium),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star,
                      size: 16,
                      color:
                      theme.colorScheme.onSurface),
                  const SizedBox(width: 4),
                  Text(
                    l.rating.toStringAsFixed(2),
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(
                        fontWeight:
                        FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
