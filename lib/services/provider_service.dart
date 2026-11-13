import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/provider.dart';

/// Loads providers from Firestore, with a curated demo seed used when Firebase
/// is unavailable or the directory is empty.
class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  FirebaseFirestore? _firestoreInstance;
  FirebaseFirestore get _firestore =>
      _firestoreInstance ??= FirebaseFirestore.instance;

  bool get isFirebaseReady => Firebase.apps.isNotEmpty;

  /// Providers shown on the home screen when Firestore has no data yet.
  List<Provider> featuredProviders() {
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
        about:
            'Experienced barber with over 10 years of experience. Specializing in fading and beard trims. I provide a premium service with hot towel shave and facial massage.',
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
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
        about:
            'Certified mobile technician. We come to you! Specializing in iPhone and Samsung repairs. Fast, reliable, and affordable.',
        services: [
          'Screen Repair',
          'Battery Replacement',
          'Water Damage',
          'Diagnostic',
        ],
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
        about:
            'Expert hair stylist with a focus on modern cuts and color treatments.',
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
        imageUrl:
            'https://images.pexels.com/photos/327072/pexels-photo-327072.jpeg?auto=compress&cs=tinysrgb&w=400',
        about:
            'Emergency plumbing and general maintenance for homes and offices.',
        services: [
          'Leak Repair',
          'Installation',
          'Drain Cleaning',
          'Emergency',
        ],
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
        about:
            'Premium cleaning services for residential and commercial properties.',
        services: [
          'Deep Clean',
          'Office Cleaning',
          'Post-Construction',
          'Daily Maid',
        ],
      ),
    ];
  }

  /// Demo providers used when Firestore has no matching records.
  List<Provider> seedForCategory(String category) {
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
          about:
              'Specialist in authentic African braids and modern hair styles in Enugu.',
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
          about:
              'Bridal makeup and special occasion looks. Based in Independence Layout.',
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
          about:
              'Certified mobile technician. Specializing in iPhone & Android repairs.',
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

  /// Fetch providers for a category from Firestore, falling back to the demo
  /// seed when Firebase is not ready or no matching records exist.
  Future<List<Provider>> fetchProviders(String category) async {
    if (!isFirebaseReady) return seedForCategory(category);

    try {
      final normalized = category == 'Tech' ? 'Phone Tech' : category;
      final snapshot = await _firestore
          .collection('providers')
          .where('category', isEqualTo: normalized)
          .limit(50)
          .get();

      final providers = snapshot.docs.map(Provider.fromFirestore).toList();
      return providers.isEmpty ? seedForCategory(category) : providers;
    } catch (_) {
      return seedForCategory(category);
    }
  }

  /// Fetch featured/verified providers for the home screen.
  Future<List<Provider>> fetchFeatured() async {
    if (!isFirebaseReady) return featuredProviders();

    try {
      final snapshot = await _firestore
          .collection('providers')
          .where('isVerified', isEqualTo: true)
          .limit(10)
          .get();

      final providers = snapshot.docs.map(Provider.fromFirestore).toList();
      return providers.isEmpty ? featuredProviders() : providers;
    } catch (_) {
      return featuredProviders();
    }
  }

  Future<Provider?> fetchProvider(String providerId) async {
    if (!isFirebaseReady) {
      for (final provider in featuredProviders()) {
        if (provider.id == providerId) return provider;
      }
      return null;
    }
    try {
      final doc = await _firestore
          .collection('providers')
          .doc(providerId)
          .get();
      if (!doc.exists) return null;
      return Provider.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }
}
