import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_address.dart';

class AddressService {
  static final AddressService _instance = AddressService._internal();
  factory AddressService() => _instance;
  AddressService._internal();

  static const String _storageKey = 'swiftserve_saved_addresses';
  static const String _activeIdKey = 'swiftserve_active_address_id';

  final ValueNotifier<List<SavedAddress>> addressesNotifier = ValueNotifier<List<SavedAddress>>([]);
  final ValueNotifier<SavedAddress?> selectedAddressNotifier = ValueNotifier<SavedAddress?>(null);
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey);

    List<SavedAddress> list = [];
    if (jsonList != null && jsonList.isNotEmpty) {
      list = jsonList.map((str) => SavedAddress.fromJson(jsonDecode(str) as Map<String, dynamic>)).toList();
    } else {
      // Seed default preset addresses for instant usability
      list = [
        const SavedAddress(
          id: 'addr_home',
          title: 'Home',
          addressLine: 'Plot 18 Independence Layout, Enugu',
          tag: 'home',
          isDefault: true,
        ),
        const SavedAddress(
          id: 'addr_work',
          title: 'Work / Office',
          addressLine: '42 Chime Avenue, New Haven, Enugu',
          tag: 'work',
          isDefault: false,
        ),
      ];
      await _persist(list);
    }

    addressesNotifier.value = list;

    final activeId = prefs.getString(_activeIdKey);
    if (activeId != null && list.any((a) => a.id == activeId)) {
      selectedAddressNotifier.value = list.firstWhere((a) => a.id == activeId);
    } else {
      selectedAddressNotifier.value = list.firstWhere((a) => a.isDefault, orElse: () => list.first);
    }

    _initialized = true;
  }

  Future<void> selectAddress(SavedAddress address) async {
    selectedAddressNotifier.value = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeIdKey, address.id);
  }

  Future<void> addAddress(SavedAddress address) async {
    final current = List<SavedAddress>.from(addressesNotifier.value);
    // If set as default, remove default from others
    if (address.isDefault) {
      for (int i = 0; i < current.length; i++) {
        current[i] = current[i].copyWith(isDefault: false);
      }
    }
    current.add(address);
    addressesNotifier.value = current;
    await _persist(current);
    if (selectedAddressNotifier.value == null || address.isDefault) {
      await selectAddress(address);
    }
  }

  Future<void> deleteAddress(String id) async {
    final current = List<SavedAddress>.from(addressesNotifier.value);
    current.removeWhere((a) => a.id == id);
    addressesNotifier.value = current;
    await _persist(current);
    if (selectedAddressNotifier.value?.id == id && current.isNotEmpty) {
      await selectAddress(current.first);
    }
  }

  Future<void> _persist(List<SavedAddress> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  /// Simulates real-time GPS auto-detect location lookup
  Future<SavedAddress> detectCurrentGPSLocation() async {
    // Simulate satellite / network fix delay
    await Future.delayed(const Duration(milliseconds: 900));

    final gpsDetected = SavedAddress(
      id: 'gps_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Current Location (GPS)',
      addressLine: 'Near Okpara Square, Independence Layout, Enugu',
      tag: 'other',
      isDefault: false,
    );

    await addAddress(gpsDetected);
    await selectAddress(gpsDetected);
    return gpsDetected;
  }
}
