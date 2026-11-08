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
  final bool isVerified;
  final bool isAvailable;
  final Map<String, bool> availability; // e.g., {"monday": true, "tuesday": false}
  final DateTime? lastSeen;
  final String? specialty;

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
    this.isVerified = false,
    this.isAvailable = true,
    this.availability = const {},
    this.lastSeen,
    this.specialty,
  });

  Provider copyWith({
    String? id,
    String? name,
    String? role,
    double? rating,
    int? reviewsCount,
    String? distance,
    double? priceStart,
    String? imageUrl,
    String? about,
    List<String>? services,
    bool? isVerified,
    bool? isAvailable,
    Map<String, bool>? availability,
    DateTime? lastSeen,
    String? specialty,
  }) {
    return Provider(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      distance: distance ?? this.distance,
      priceStart: priceStart ?? this.priceStart,
      imageUrl: imageUrl ?? this.imageUrl,
      about: about ?? this.about,
      services: services ?? this.services,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      availability: availability ?? this.availability,
      lastSeen: lastSeen ?? this.lastSeen,
      specialty: specialty ?? this.specialty,
    );
  }
}
