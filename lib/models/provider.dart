class Provider {
  final String id;
  final String name;
  final String role;
  final double rating;
  final int reviewsCount;
  final String distance;
  final double priceStart;
  final String imageUrl;
  final String about;
  final List<String> services;

  Provider({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.priceStart,
    required this.imageUrl,
    required this.about,
    required this.services,
  });
}
