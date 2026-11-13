import 'package:cloud_firestore/cloud_firestore.dart';

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
  final Map<String, bool>
  availability; // e.g., {"monday": true, "tuesday": false}
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

  factory Provider.fromFirestore(DocumentSnapshot snapshot) {
    final data =
        (snapshot.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    final rawAvailability = data['availability'];
    final availability = <String, bool>{};
    if (rawAvailability is Map) {
      rawAvailability.forEach((key, value) {
        availability[key.toString()] = value == true;
      });
    }

    final lastSeen = data['lastSeen'];
    return Provider(
      id: data['uid'] as String? ?? data['id'] as String? ?? snapshot.id,
      name: data['name'] as String? ?? '',
      role:
          data['category'] as String? ??
          data['specialty'] as String? ??
          'Service Professional',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 0,
      distance: data['distance'] as String? ?? '',
      priceStart: (data['priceStart'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String? ?? '',
      about: data['bio'] as String? ?? data['about'] as String? ?? '',
      services: List<String>.from(data['services'] as List? ?? const []),
      isVerified: data['isVerified'] as bool? ?? false,
      isAvailable: data['isAvailable'] as bool? ?? true,
      availability: availability,
      lastSeen: lastSeen is Timestamp ? lastSeen.toDate() : null,
      specialty: data['specialty'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': id,
      'name': name,
      'category': role,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'priceStart': priceStart,
      'imageUrl': imageUrl,
      'bio': about,
      'services': services,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'availability': availability,
      'lastSeen': lastSeen == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(lastSeen!),
      'specialty': specialty ?? '',
    };
  }

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
