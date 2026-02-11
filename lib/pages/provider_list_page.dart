import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider.dart';
import 'provider_details_page.dart';

class ProviderListPage extends StatelessWidget {
  final String category;

  const ProviderListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    // Mock category-specific providers
    final List<Provider> providers = _getMockProviders(category);

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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    '${providers.length} PROFESSIONALS FOUND',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.grey[500],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    itemCount: providers.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 20),
                    itemBuilder: (context, index) => _buildProviderCard(context, providers[index], neonGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                category.toUpperCase(),
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
                          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
                          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${provider.priceStart.toInt()}',
                        style: GoogleFonts.spaceGrotesk(color: neonGreen, fontSize: 18, fontWeight: FontWeight.bold),
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
          imageUrl: 'https://images.unsplash.com/photo-1595152772835-219674b2a8a6?auto=format&fit=crop&w=400&q=80',
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
          imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=400&q=80',
          about: 'Bridal makeup and special occasion looks. Based in Independence Layout.',
          services: ['Bridal Makeup', 'Photo Session', 'Gele Tying'],
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
        distance: '1.2 mi',
        priceStart: 25,
        imageUrl: 'https://images.unsplash.com/photo-1540560914876-a69739489830?auto=format&fit=crop&w=400&q=80',
        about: 'Trusted $category in the heart of Enugu.',
        services: ['Primary Service', 'Secondary Service', 'Diagnostic'],
      ),
    ];
  }
}
