// lib/screens/customer_profile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:provider/provider.dart'; // Added for state management
import 'package:elma/models/user_model.dart'; // Added for UserModel

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4; // 4 = Profile tab

  // Update index 3 to point at '/inbox'
  static const _routes = [
    '/explore',
    '/wishlist',
    '/services',
    '/inbox',    // ← was '/inbox.dart'
    '/customer',
  ];

  void _onTabTapped(int idx) {
    if (idx == _currentIndex) return;
    Navigator.pushReplacementNamed(context, _routes[idx]);
  }

  @override
  Widget build(BuildContext context) {
    // Get user data from providers
    final firebaseUser = context.watch<User?>();
    final userProfile = context.watch<UserModel?>();

    // Example customer data - replace with actual data from userProfile
    // const avatarUrl = 'https://i.pravatar.cc/150?img=12';
    // const name = 'Jane Doe';
    // const memberSince = 'Jan 2021';
    // const bookings = 18;
    // const reviewsWritten = 7;

    String displayName = userProfile?.displayName ?? firebaseUser?.displayName ?? 'User Name';
    String photoUrl = userProfile?.photoUrl ?? firebaseUser?.photoURL ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80'; // Default placeholder
    String memberSince = userProfile?.createdAt != null 
        ? 'Joined ${userProfile!.createdAt!.toDate().year}-${userProfile.createdAt!.toDate().month.toString().padLeft(2,'0')}' 
        : (firebaseUser?.metadata.creationTime != null 
            ? 'Joined ${firebaseUser!.metadata.creationTime!.year}-${firebaseUser.metadata.creationTime!.month.toString().padLeft(2,'0')}' 
            : 'N/A');

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false, // no back button here
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Customer Profile',
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            ),
            actions: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  '9:41',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(photoUrl), // Use dynamic photoUrl
                ),
                const SizedBox(height: 12),
                Text(
                  displayName, // Use dynamic displayName
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  memberSince, // Use dynamic memberSince
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                if (userProfile != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatCard(label: 'Bookings', value: 'N/A'), // Placeholder, to be implemented if needed
                      _StatCard(label: 'Reviews', value: userProfile.totalServiceReviews?.toString() ?? '0'),
                    ],
                  ),
                ] else ...[
                  const Text("Loading profile stats..."),
                ],
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userProfile?.aboutMe ?? (userProfile?.isServiceProvider == true ? userProfile?.providerBio : 'No bio available.') ?? 'Loading bio...',
                        style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reviews Written',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(2, (i) => const _ReviewTile()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.home_repair_service, color: Theme.of(context).primaryColor),
                      title: Text(
                        'Manage Services',
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/service-management');
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red[700]),
                      title: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        // The StreamProvider in main.dart handles the state change.
                        // This navigation ensures we pop back to the root controlled by AuthWrapper.
                        if (mounted) { // Check if the widget is still in the tree
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Electrician fix was perfect',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('★★★★★', style: TextStyle(color: Colors.orange)),
                  SizedBox(height: 4),
                  Text(
                    '“Really satisfied! Clear communication, arrived on time, and the work was top quality.”',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
