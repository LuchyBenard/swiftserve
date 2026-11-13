import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider.dart';
import '../models/provider_filter.dart';
import '../services/favorites_service.dart';
import '../services/provider_service.dart';
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
  final ProviderService _providerService = ProviderService();

  @override
  void initState() {
    super.initState();
    _favoritesService.init();
    // Show the curated seed immediately, then replace with Firestore data.
    _allProviders = _providerService.seedForCategory(widget.category);
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    final providers = await _providerService.fetchProviders(widget.category);
    if (!mounted) return;
    setState(() => _allProviders = providers);
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
                color: neonGreen.withValues(alpha: 0.05),
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
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _currentFilter = _currentFilter.copyWith(
                                  searchQuery: val,
                                );
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search by name or service...',
                              hintStyle: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white54,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white54,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _currentFilter = _currentFilter
                                              .copyWith(searchQuery: '');
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
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
                                color: _currentFilter.activeCount > 0
                                    ? neonGreen
                                    : const Color(0xFF141414),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _currentFilter.activeCount > 0
                                      ? neonGreen
                                      : Colors.white12,
                                ),
                              ),
                              child: Icon(
                                Icons.tune,
                                color: _currentFilter.activeCount > 0
                                    ? Colors.black
                                    : Colors.white,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
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
                          separatorBuilder: (c, i) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) => _buildProviderCard(
                            context,
                            filteredProviders[index],
                            neonGreen,
                          ),
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
              style: GoogleFonts.spaceGrotesk(
                color: Colors.grey[500],
                fontSize: 13,
              ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Reset All Filters',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
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
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
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

  Widget _buildProviderCard(
    BuildContext context,
    Provider provider,
    Color neonGreen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderDetailsPage(provider: provider),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF080808),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
                  errorBuilder: (c, e, s) =>
                      Container(height: 160, color: Colors.grey[900]),
                ),
                // Rating Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFF25F46A),
                          size: 12,
                        ),
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
                            color: Colors.black.withValues(alpha: 0.6),
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
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: neonGreen, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              provider.distance,
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Availability status
                            if (!provider.isAvailable) ...[
                              Icon(
                                Icons.timer_off,
                                color: Colors.red,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Unavailable',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.red,
                                  fontSize: 9,
                                ),
                              ),
                            ] else ...[
                              Icon(
                                Icons.access_time,
                                color: Colors.green,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Available',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.green,
                                  fontSize: 9,
                                ),
                              ),
                            ],
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
}
