import 'provider.dart';

class ProviderFilter {
  final double? minRating;
  final double? maxPrice;
  final bool availableToday;
  final double? maxDistance;
  final String searchQuery;
  final String sortBy; // 'rating', 'price_low', 'price_high', 'distance'

  const ProviderFilter({
    this.minRating,
    this.maxPrice,
    this.availableToday = false,
    this.maxDistance,
    this.searchQuery = '',
    this.sortBy = 'rating',
  });

  bool get isActive =>
      minRating != null ||
      maxPrice != null ||
      availableToday ||
      maxDistance != null ||
      searchQuery.isNotEmpty ||
      sortBy != 'rating';

  int get activeCount {
    int count = 0;
    if (minRating != null) count++;
    if (maxPrice != null) count++;
    if (availableToday) count++;
    if (maxDistance != null) count++;
    if (sortBy != 'rating') count++;
    return count;
  }

  ProviderFilter copyWith({
    double? minRating,
    bool clearMinRating = false,
    double? maxPrice,
    bool clearMaxPrice = false,
    bool? availableToday,
    double? maxDistance,
    bool clearMaxDistance = false,
    String? searchQuery,
    String? sortBy,
  }) {
    return ProviderFilter(
      minRating: clearMinRating ? null : (minRating ?? this.minRating),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      availableToday: availableToday ?? this.availableToday,
      maxDistance: clearMaxDistance ? null : (maxDistance ?? this.maxDistance),
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool matches(Provider provider) {
    // 1. Text search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      final matchName = provider.name.toLowerCase().contains(query);
      final matchRole = provider.role.toLowerCase().contains(query);
      final matchServices = provider.services.any((s) => s.toLowerCase().contains(query));
      if (!matchName && !matchRole && !matchServices) return false;
    }

    // 2. Minimum Rating
    if (minRating != null && provider.rating < minRating!) {
      return false;
    }

    // 3. Max Price
    if (maxPrice != null && provider.priceStart > maxPrice!) {
      return false;
    }

    // 4. Distance
    if (maxDistance != null) {
      final numStr = provider.distance.replaceAll(RegExp(r'[^0-9.]'), '');
      final dist = double.tryParse(numStr) ?? 999.0;
      if (dist > maxDistance!) return false;
    }

    // 5. Available today (mock availability heuristic: providers under 2.0 mi or rating >= 4.8)
    if (availableToday) {
      final numStr = provider.distance.replaceAll(RegExp(r'[^0-9.]'), '');
      final dist = double.tryParse(numStr) ?? 999.0;
      if (dist > 2.0 && provider.rating < 4.9) return false;
    }

    return true;
  }

  List<Provider> apply(List<Provider> providers) {
    final filtered = providers.where(matches).toList();

    filtered.sort((a, b) {
      switch (sortBy) {
        case 'price_low':
          return a.priceStart.compareTo(b.priceStart);
        case 'price_high':
          return b.priceStart.compareTo(a.priceStart);
        case 'distance':
          final distA = double.tryParse(a.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
          final distB = double.tryParse(b.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
          return distA.compareTo(distB);
        case 'rating':
        default:
          return b.rating.compareTo(a.rating);
      }
    });

    return filtered;
  }
}
