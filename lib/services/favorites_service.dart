import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/provider.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static const String _storageKey = 'swiftserve_favorite_providers';
  final ValueNotifier<Set<String>> favoritesNotifier = ValueNotifier<Set<String>>({});
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_storageKey) ?? [];
    favoritesNotifier.value = list.toSet();
    _initialized = true;
  }

  bool isFavorite(String providerId) {
    return favoritesNotifier.value.contains(providerId);
  }

  Future<bool> toggleFavorite(String providerId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = Set<String>.from(favoritesNotifier.value);
    bool added;
    if (current.contains(providerId)) {
      current.remove(providerId);
      added = false;
    } else {
      current.add(providerId);
      added = true;
    }
    favoritesNotifier.value = current;
    await prefs.setStringList(_storageKey, current.toList());
    return added;
  }

  List<Provider> filterSavedProviders(List<Provider> allProviders) {
    final ids = favoritesNotifier.value;
    return allProviders.where((p) => ids.contains(p.id)).toList();
  }
}
