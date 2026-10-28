import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider.dart';
import '../services/favorites_service.dart';
import 'provider_details_page.dart';

class SavedProvidersPage extends StatefulWidget {
  final List<Provider>? allProviders;

  const SavedProvidersPage({super.key, this.allProviders});

  @override
  State<SavedProvidersPage> createState() => _SavedProvidersPageState();
}

class _SavedProvidersPageState extends State<SavedProvidersPage> {
  final FavoritesService _favoritesService = FavoritesService();

  late final List<Provider> _providerPool;

  @override
  void initState() {
    super.initState();
    _favoritesService.init();
    _providerPool = widget.allProviders ?? _getDefaultProviderPool();
  }

  List<Provider> _getDefaultProviderPool() {
    return [
      Provider(
        id: '1',
        name: 'John D.',
        role: 'Master Barber',
        rating: 4.9,
        reviewsCount: 128,
        distance: '0.5 mi',
        priceStart: 40,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
        about: 'Experienced master barber.',
        services: ['Haircut', 'Beard Trim', 'Hot Towel Shave'],
      ),
      Provider(
        id: '2',
        name: 'TechFix Mobile',
        role: 'Technician',
        rating: 5.0,
        reviewsCount: 85,
        distance: '1.2 mi',
        priceStart: 85,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
        about: 'Mobile technician for smartphone repairs.',
        services: ['Screen Repair', 'Battery Replacement', 'Diagnostic'],
      ),
      Provider(
        id: '3',
        name: 'Sarah M.',
        role: 'Professional Stylist',
        rating: 4.8,
        reviewsCount: 92,
        distance: '2.1 mi',
        priceStart: 60,
        imageUrl:
            'https://images.pexels.com/photos/1181681/pexels-photo-1181681.jpeg?auto=compress&cs=tinysrgb&w=400',
        about: 'Modern hair styling and treatments.',
        services: ['Hair Coloring', 'Modern Cuts', 'Styling'],
      ),
      Provider(
        id: '4',
        name: 'Fix-It Mike',
        role: 'Master Plumber',
        rating: 4.7,
        reviewsCount: 45,
        distance: '1.8 mi',
        priceStart: 50,
        imageUrl:
            'https://images.pexels.com/photos/327072/pexels-photo-327072.jpeg?auto=compress&cs=tinysrgb&w=400',
        about: 'Emergency plumbing repairs.',
        services: ['Leak Repair', 'Installation', 'Drain Cleaning'],
      ),
      Provider(
        id: '5',
        name: 'CleanPro Enugu',
        role: 'Professional Cleaner',
        rating: 5.0,
        reviewsCount: 210,
        distance: '0.3 mi',
        priceStart: 30,
        imageUrl:
            'https://images.pexels.com/photos/3768910/pexels-photo-3768910.jpeg?auto=compress&cs=tinysrgb&w=400',
        about: 'Residential and commercial cleaning.',
        services: ['Deep Clean', 'Office Cleaning', 'Daily Maid'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Saved Providers',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: _favoritesService.favoritesNotifier,
        builder: (context, favoriteIds, _) {
          final savedList = _providerPool.where((p) => favoriteIds.contains(p.id)).toList();

          if (savedList.isEmpty) {
            return _buildEmptyState(primaryGreen);
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: savedList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final provider = savedList[index];
              return _buildProviderCard(provider, primaryGreen);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Color primaryGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: const Icon(Icons.favorite_border, color: Colors.white38, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Providers Yet',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any provider profile to easily find and book them later.',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Explore Providers',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(Provider provider, Color primaryGreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProviderDetailsPage(provider: provider)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  provider.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: Colors.grey[900],
                    child: const Icon(Icons.person, color: Colors.white38, size: 48),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      await _favoritesService.toggleFavorite(provider.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.favorite, color: Colors.redAccent, size: 18),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
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
                        Text(
                          ' (${provider.reviewsCount})',
                          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
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
                        Text(
                          provider.role,
                          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: primaryGreen, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              provider.distance,
                              style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Starts at',
                        style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 10),
                      ),
                      Text(
                        '\$${provider.priceStart.toInt()}',
                        style: GoogleFonts.spaceGrotesk(
                          color: primaryGreen,
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
