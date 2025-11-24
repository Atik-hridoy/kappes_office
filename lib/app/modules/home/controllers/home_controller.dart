import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/netwok/home/home_view_service.dart';
import '../../../model/recomended_item_model.dart';
// Import Item model

class HomeController extends GetxController {
  var isLoading = true.obs;
  var recommendedItems = <Item>[].obs;

  // Current selected address shown in AppBar
  var currentAddress = 'Edmonton, Alberta'.obs;

  static const String _kLastLocationKey = 'last_location';

  /// Load last saved location (if any) and set currentAddress.
  Future<void> _loadLastLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final s = prefs.getString(_kLastLocationKey);
      if (s == null) {
        AppLogger.info('No saved location found.');
        return;
      }
      final data = jsonDecode(s) as Map<String, dynamic>;
      final addr = (data['address'] ?? '').toString();
      if (addr.isNotEmpty) {
        updateAddress(addr);
        AppLogger.info('Loaded last location: $addr');
      } else if (data['latitude'] != null && data['longitude'] != null) {
        final lat = data['latitude'];
        final lng = data['longitude'];
        final coordStr = '$lat, $lng';
        updateAddress(coordStr);
        AppLogger.info('Loaded last coordinates: $coordStr');
      }
    } catch (e, st) {
      AppLogger.error('Failed to load last location', error: e, context: {'stack': st.toString()});
    }
  }

  // Update the current address (called after selecting location)
  void updateAddress(String address) {
    if (address.isEmpty) return;

    // Remove any standalone "search" word/prefix (case-insensitive) and trailing punctuation/whitespace
    // Dart RegExp does not support inline (?i). Use caseSensitive:false instead.
    var cleaned = address.replaceAll(
      RegExp(r'\bsearch\b[:\s-]*', caseSensitive: false),
      '',
    ).trim();

    // Show only the location name (first segment before comma)
    final name = cleaned.split(',').map((s) => s.trim()).firstWhere((s) => s.isNotEmpty, orElse: () => cleaned);

    currentAddress.value = name;
  }

  // Get device location, reverse-geocode it, update currentAddress and print to console.
  Future<void> logCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      print('Current position: ${pos.latitude}, ${pos.longitude}');

      try {
        final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final addrParts = [
            p.name,
            p.street,
            p.subLocality,
            p.locality,
            p.administrativeArea,
            p.country
          ].where((s) => s != null && s.isNotEmpty).map((s) => s!.trim()).toList();
          final addr = addrParts.join(', ');
          print('Address: $addr');
          updateAddress(addr);
        }
      } catch (e) {
        print('Reverse geocode failed: $e');
      }
    } catch (e) {
      print('Could not get current location: $e');
    }
  }

  // Instance of the service
  final HomeViewService _homeViewService = HomeViewService();

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedProducts(); // Fetch products when the controller is initialized
    // Load saved location first (display persisted location until changed).
    _loadLastLocation().then((_) {
      // After loading saved location, optionally also get fresh device location if you want:
      logCurrentLocation();
    });
  }

  // Function to fetch recommended products
  void fetchRecommendedProducts() async {
    try {
      isLoading(true); // Set loading state to true
      final items =
      await _homeViewService
          .fetchRecommendedProducts(); // Fetch products from the service
      recommendedItems.assignAll(
        items,
      ); // Assign the fetched products to the observable list
      AppLogger.info('✅ Recommended Items fetched successfully!');
    } catch (e) {
      AppLogger.error('❌ Error fetching recommended items: $e', error: 'Error fetching recommended items: $e');
    } finally {
      isLoading(false); // Set loading state to false
    }
  }
}