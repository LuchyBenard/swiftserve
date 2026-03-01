import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider.dart';
import 'provider_details_page.dart';
import 'provider_list_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Phone Tech';

  // Mock Data
  final List<Provider> _providers = [
    Provider(
      id: '1',
      name: 'John D.',
      role: 'Master Barber',
      rating: 4.9,
      reviewsCount: 128,
      distance: '0.5 mi',
      priceStart: 40,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
      about: 'Experienced barber with over 10 years of experience. Specializing in fading and beard trims. I provide a premium service with hot towel shave and facial massage.',
      services: ['Haircut', 'Beard Trim', 'Hot Towel Shave', 'Facial'],
    ),
    Provider(
      id: '2',
      name: 'TechFix Mobile',
      role: 'Technician',
      rating: 5.0,
      reviewsCount: 85,
      distance: '1.2 mi',
      priceStart: 85,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
      about: 'Certified mobile technician. We come to you! Specializing in iPhone and Samsung repairs. Fast, reliable, and affordable.',
      services: ['Screen Repair', 'Battery Replacement', 'Water Damage', 'Diagnostic'],
    ),
    Provider(
      id: '3',
      name: 'Sarah M.',
      role: 'Professional Stylist',
      rating: 4.8,
      reviewsCount: 92,
      distance: '2.1 mi',
      priceStart: 60,
      imageUrl: 'https://images.pexels.com/photos/1181681/pexels-photo-1181681.jpeg?auto=compress&cs=tinysrgb&w=400',
      about: 'Expert hair stylist with a focus on modern cuts and color treatments.',
      services: ['Hair Coloring', 'Modern Cuts', 'Styling', 'Treatment'],
    ),
    Provider(
      id: '4',
      name: 'Fix-It Mike',
      role: 'Master Plumber',
      rating: 4.7,
      reviewsCount: 45,
      distance: '1.8 mi',
      priceStart: 50,
      imageUrl: 'https://images.pexels.com/photos/327072/pexels-photo-327072.jpeg?auto=compress&cs=tinysrgb&w=400',
      about: 'Emergency plumbing and general maintenance for homes and offices.',
      services: ['Leak Repair', 'Installation', 'Drain Cleaning', 'Emergency'],
    ),
    Provider(
      id: '5',
      name: 'CleanPro Enugu',
      role: 'Professional Cleaner',
      rating: 5.0,
      reviewsCount: 210,
      distance: '0.3 mi',
      priceStart: 30,
      imageUrl: 'https://images.pexels.com/photos/3768910/pexels-photo-3768910.jpeg?auto=compress&cs=tinysrgb&w=400',
      about: 'Premium cleaning services for residential and commercial properties.',
      services: ['Deep Clean', 'Office Cleaning', 'Post-Construction', 'Daily Maid'],
    ),
  ];
  
  // Filter providers essentially just ensures we show something relevant. 
  // For this mock, we'll just show all of them unless a filter logic is added later.
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 32),
          _buildCategories(),
          const SizedBox(height: 32),
          _buildPremiumProviders(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'SwiftServe',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF25F46A),
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(
                          color: Color(0xFF25F46A),
                          blurRadius: 8,
                           spreadRadius: 1,
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'READY TO SERVE',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[400],
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
               // Functional Profile Avatar
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const ProfilePage()),
               );
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color.fromRGBO(37, 244, 106, 0.2), width: 2),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // Functional Search Bar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProviderListPage(category: 'Services')),
        );
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.search, color: Colors.grey[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Where to next?',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ),
                 Container(
                   height: 24,
                   width: 1,
                   color: const Color.fromRGBO(255, 255, 255, 0.1),
                 ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    // Logic for filters or advanced search
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter options coming soon!')),
                    );
                  },
                  icon: Icon(Icons.tune, color: Colors.grey[400], size: 20),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.smartphone, 'label': 'Phone Tech'},
      {'icon': Icons.content_cut, 'label': 'Barber'},
      {'icon': Icons.face, 'label': 'Stylist'},
      {'icon': Icons.plumbing, 'label': 'Plumber'},
      {'icon': Icons.cleaning_services, 'label': 'Cleaner'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((cat) {
            final label = cat['label'] as String;
            final isActive = _selectedCategory == label;
            
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = label);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProviderListPage(category: label),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF25F46A) : const Color(0xFF0F0F0F),
                        shape: BoxShape.circle,
                        border: isActive ? null : Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
                        boxShadow: isActive ? [
                          const BoxShadow(
                            color: Color.fromRGBO(37, 244, 106, 0.4),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          )
                        ] : null,
                      ),
                      child: Icon(
                        cat['icon'] as IconData,
                        color: isActive ? Colors.black : Colors.grey[400],
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      label.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        color: isActive ? const Color(0xFF25F46A) : Colors.grey[500],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
        }).toList(),
      ),
    );
  }

  Widget _buildPremiumProviders() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Premium Providers',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'View All',
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF25F46A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._providers.map((provider) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildProviderCard(provider),
            )).toList(),
          ],
        ),
    );
  }

  Widget _buildProviderCard(Provider provider) {
    return GestureDetector(
      onTap: () {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => ProviderDetailsPage(provider: provider)),
         );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF080808),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.05)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  provider.imageUrl,
                  height: 192,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 192,
                      width: double.infinity,
                      color: Colors.grey[900],
                      child: Icon(Icons.broken_image, color: Colors.grey[700]),
                    );
                  },
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Color(0xFF25F46A), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            provider.rating.toString(),
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              provider.role,
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                           Text(
                            '•',
                            style: TextStyle(color: Colors.grey[400], fontSize: 10),
                          ),
                           const SizedBox(width: 8),
                           Text(
                            provider.distance,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'STARTING AT',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '\$${provider.priceStart.toInt()}',
                        style: GoogleFonts.spaceGrotesk(
                          color: const Color(0xFF25F46A),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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

