import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider.dart';
import '../models/provider_filter.dart';
import '../services/favorites_service.dart';
import '../widgets/provider_filter_sheet.dart';
import 'provider_details_page.dart';

class ProviderListPage extends StatefulWidget {
  final String category;

  const ProviderListPage({super.key, required this.category});

  @override
  State<ProviderListPage> createState() => _ProviderListPageState();
}

class _ProviderListPageState extends State<ProviderListPage> {
  late List<Provider> _allProviders;
  ProviderFilter _currentFilter = const ProviderFilter();
  final TextEditingController _searchController = TextEditingController();
  final FavoritesService _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _favoritesService.init();
    _allProviders = _getMockProviders(widget.category);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);
    final filteredProviders = _currentFilter.apply(_allProviders);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: neonGreen.withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, neonGreen),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Search field
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141414),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
                            onChanged: (val) {
                              setState(() {
                                _currentFilter = _currentFilter.copyWith(searchQuery: val);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search by name or service...',
                              hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 13),
                              prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.white54, size: 16),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _currentFilter = _currentFilter.copyWith(searchQuery: '');
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Filter Button with Badge
                      GestureDetector(
                        onTap: () {
                          ProviderFilterSheet.show(
                            context: context,
                            currentFilter: _currentFilter,
                            onApply: (updated) {
                              setState(() {
                                _currentFilter = updated;
                              });
                            },
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: _currentFilter.activeCount > 0 ? neonGreen : const Color(0xFF141414),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _currentFilter.activeCount > 0 ? neonGreen : Colors.white12,
                                ),
                              ),
                              child: Icon(
                                Icons.tune,
                                color: _currentFilter.activeCount > 0 ? Colors.black : Colors.white,
                                size: 22,
                              ),
                            ),
                            if (_currentFilter.activeCount > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_currentFilter.activeCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredProviders.length} PROFESSIONALS FOUND',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (_currentFilter.isActive)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {
                              _currentFilter = const ProviderFilter();
                            });
                          },
                          child: Text(
                            'CLEAR FILTERS',
                            style: GoogleFonts.spaceGrotesk(
                              color: neonGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredProviders.isEmpty
                      ? _buildEmptyState(neonGreen)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                          itemCount: filteredProviders.length,
                          separatorBuilder: (c, i) => const SizedBox(height: 20),
                          itemBuilder: (context, index) =>
                              _buildProviderCard(context, filteredProviders[index], neonGreen),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color neonGreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: Colors.white24, size: 54),
            const SizedBox(height: 16),
            Text(
              'No Professionals Found',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria, price range, or distance limits.',
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() => _currentFilter = const ProviderFilter());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Reset All Filters',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ENUGU, NIGERIA',
                style: GoogleFonts.spaceGrotesk(
                  color: neonGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, Provider provider, Color neonGreen) {
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
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  provider.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 160, color: Colors.grey[900]),
                ),
                // Rating Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Color(0xFF25F46A), size: 12),
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
                // Quick Heart / Favorite Button
                Positioned(
                  top: 16,
                  left: 16,
                  child: ValueListenableBuilder<Set<String>>(
                    valueListenable: _favoritesService.favoritesNotifier,
                    builder: (context, favIds, _) {
                      final isFav = favIds.contains(provider.id);
                      return GestureDetector(
                        onTap: () async {
                          await _favoritesService.toggleFavorite(provider.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : Colors.white70,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: neonGreen, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              provider.distance,
                              style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 10),
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
                        'STARTING',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey[600],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${provider.priceStart.toInt()}',
                        style: GoogleFonts.spaceGrotesk(
                          color: neonGreen,
                          fontSize: 18,
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

  List<Provider> _getMockProviders(String category) {
    if (category == 'Stylist') {
      return [
        Provider(
          id: 's1',
          name: 'Chinelo A.',
          role: 'Hair Stylist & Braider',
          rating: 4.8,
          reviewsCount: 56,
          distance: '0.8 mi',
          priceStart: 35,
          imageUrl:
              'https://images.unsplash.com/photo-1595152772835-219674b2a8a6?auto=format&fit=crop&w=400&q=80',
          about: 'Specialist in authentic African braids and modern hair styles in Enugu.',
          services: ['Box Braids', 'Knotless', 'Crotchet', 'Wash & Dry'],
        ),
        Provider(
          id: 's2',
          name: 'Ngozi Boutique',
          role: 'Professional Makeup Artist',
          rating: 4.9,
          reviewsCount: 120,
          distance: '1.5 mi',
          priceStart: 50,
          imageUrl:
              'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=400&q=80',
          about: 'Bridal makeup and special occasion looks. Based in Independence Layout.',
          services: ['Bridal Makeup', 'Photo Session', 'Gele Tying'],
        ),
      ];
    }

    if (category == 'Phone Tech' || category == 'Tech') {
      return [
        Provider(
          id: 't1',
          name: 'TechFix Mobile',
          role: 'Technician',
          rating: 5.0,
          reviewsCount: 85,
          distance: '1.2 mi',
          priceStart: 85,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
          about: 'Certified mobile technician. Specializing in iPhone & Android repairs.',
          services: ['Screen Repair', 'Battery Replacement', 'Diagnostic'],
        ),
        Provider(
          id: 't2',
          name: 'Kene Micro Electronics',
          role: 'Hardware Specialist',
          rating: 4.6,
          reviewsCount: 34,
          distance: '2.5 mi',
          priceStart: 45,
          imageUrl:
              'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=400&q=80',
          about: 'Board-level repairs, port soldering, and laptop diagnostics.',
          services: ['Motherboard Repair', 'Charging Port', 'Cleaning'],
        ),
      ];
    }

    // Default mock data for other categories
    return [
      Provider(
        id: 'p1',
        name: 'Emeka Fix',
        role: 'Expert $category',
        rating: 5.0,
        reviewsCount: 42,
        distance: '0.9 mi',
        priceStart: 25,
        imageUrl:
            'https://images.unsplash.com/photo-1540560914876-a69739489830?auto=format&fit=crop&w=400&q=80',
        about: 'Trusted $category in the heart of Enugu.',
        services: ['Primary Service', 'Secondary Service', 'Diagnostic'],
      ),
      Provider(
        id: 'p2',
        name: 'John D.',
        role: 'Master Barber',
        rating: 4.9,
        reviewsCount: 128,
        distance: '0.5 mi',
        priceStart: 40,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
        about: 'Premium haircutting and grooming services.',
        services: ['Haircut', 'Beard Trim', 'Hot Towel'],
      ),
      Provider(
        id: 'p3',
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
    ];
  }
}
