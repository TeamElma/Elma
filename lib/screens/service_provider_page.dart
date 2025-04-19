import 'package:flutter/material.dart';

class ServiceProviderPage extends StatefulWidget {
  const ServiceProviderPage({Key? key}) : super(key: key);

  @override
  State<ServiceProviderPage> createState() => _ServiceProviderPageState();
}

class _ServiceProviderPageState extends State<ServiceProviderPage> {
  bool _isFavorite = false;
  final double _rating = 4.95;
  final int _reviews = 22;
  final int _monthsWorking = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: const BackButton(color: Colors.black),
              ),
            ),
            title: const Text(
              'Explore / Listing',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            centerTitle: false,
            actions: [
              Container(
                width: 80,
                alignment: Alignment.center,
                child: const Text(
                  '9:41',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider Image
                Stack(
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=2069&auto=format&fit=crop',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.share, color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                _isFavorite ? Colors.red : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Provider Info
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ali Ahmet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Electrician',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.black),
                          Text(
                            ' $_rating · $_reviews reviews',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Text(' · ', style: TextStyle(fontSize: 14)),
                          const Text(
                            'Superworker',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Orta, Tuzla, Istanbul, Türkiye',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(height: 32),
                    ],
                  ),
                ),

                // Service Categories
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Electrical Services by Ali',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/150?img=8',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildServiceCategory(
                            icon: Icons.bed,
                            title: 'Electrical Wiring & Installation',
                          ),
                          _buildServiceCategory(
                            icon: Icons.electrical_services,
                            title: 'Circuit Breaker & Fuse Repair',
                          ),
                          _buildServiceCategory(
                            icon: Icons.home,
                            title: 'Lighting & Smart Home Setup',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildServiceFeature(
                        icon: Icons.build,
                        title: 'Reliable & Safe Electrical Repairs',
                        description:
                        'Expert troubleshooting, panel upgrades, and wiring fixes for homes and offices.',
                      ),
                      const SizedBox(height: 16),
                      _buildServiceFeature(
                        icon: Icons.lightbulb,
                        title: 'Smart Home & Energy Efficiency',
                        description:
                        'Install modern lighting, automation, and energy-saving solutions.',
                      ),
                      const SizedBox(height: 16),
                      _buildServiceFeature(
                        icon: Icons.verified,
                        title: 'Guaranteed Safety & Compliance',
                        description: '',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Some info has been automatically translated.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Meet Your Helper
                      const Text(
                        'Meet your helper',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=8',
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Glowen',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Superworker',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '$_reviews',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16),
                                    Text(
                                      ' $_rating',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Rating',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_monthsWorking',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Months working',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 32),

                      // About Section
                      _buildAboutSection(),

                      const Divider(height: 32),

                      // Co-helpers Section
                      _buildCoHelpersSection(),

                      const Divider(height: 32),

                      // About this service
                      _buildAboutServiceSection(),

                      const Divider(height: 32),

                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      '\$77 ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text('hour', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const Text(
                  'Jun 25 – 30',
                  style: TextStyle(decoration: TextDecoration.underline, fontSize: 14),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Reserve',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategory({required IconData icon, required String title}) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (description.isNotEmpty)
                Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    Widget infoRow(IconData i, String t) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(i, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        infoRow(Icons.lightbulb_outline, 'Born in the 70s'),
        infoRow(Icons.work, 'My work: Business owner'),
        infoRow(Icons.access_time, 'I spend too much time: My job, travel, motorsport'),
        infoRow(Icons.person, 'For clients, I always: Advice the friendly addresses of Nantes'),
        infoRow(Icons.pets, 'Hobbies: I love cats, we have two.'),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Show more', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoHelpersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Co-helpers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=9')),
            const SizedBox(width: 12),
            const Text('Emre Ahmet', style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/inbox');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Message Host'),
        ),
        const SizedBox(height: 16),
        const Text(
          'To protect your payment, never transfer money or communicate outside of the Elma website or app.',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildAboutServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About this service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text(
          'Get expert electrical services for your home or business, ensuring safe, high‑quality repairs and installations. Whether you need wiring fixes, panel upgrades, or emergency support, our certified electricians are here to help.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Show more', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }
}
