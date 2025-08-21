import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocationViewController extends GetxController {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  static const String _kLastLocationKey = 'last_location';

  // Debounce for search input
  Timer? _debounce;

  // Search history
  RxList<String> searchHistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(onSearchChanged);
    _loadSearchHistory();
  }

  // Handle search text changes
  void onSearchChanged() {
    final input = searchController.text.trim();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () => _handleSearch(input));
  }

  // Handle the search input (address or coordinates)
  void _handleSearch(String input) async {
    if (input.isEmpty) return;

    try {
      final locations = await locationFromAddress(input);
      if (locations.isNotEmpty) {
        final first = locations.first;
        moveToLocation(LatLng(first.latitude, first.longitude), label: 'Search: $input');
        _addToSearchHistory(input);
      } else {
        Get.snackbar("Not Found", "No location found for \"$input\"");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to search for \"$input\"");
    }
  }

  // Move the map camera to the specified location
  void moveToLocation(LatLng pos, {String label = 'Selected Location'}) {
    selectedMarker.value = Marker(
      markerId: MarkerId('selected'),
      position: pos,
      infoWindow: InfoWindow(title: label),
    );

    if (mapController != null) {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 14));
    }
  }

  /// Save the currently selected marker as last location and return it to caller.
  Future<void> confirmSelection() async {
    final marker = selectedMarker.value;
    if (marker == null) {
      Get.snackbar('No location', 'Please select a location first.');
      return;
    }

    final data = {
      'latitude': marker.position.latitude,
      'longitude': marker.position.longitude,
      'address': marker.infoWindow.title ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastLocationKey, jsonEncode(data));
      // Return the picked location to previous route
      Get.back(result: data);
    } catch (e) {
      Get.snackbar('Error', 'Could not save location');
    }
  }

  // Get the user's current location
  Future<void> useCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      searchController.text = "${pos.latitude}, ${pos.longitude}";
      moveToLocation(pos, label: 'Current Location');
    }
  }

  // Fetch the current location using Geolocator
  Future<LatLng?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location Disabled', 'Please enable GPS to use location services');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission is required to access your current location');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied Forever',
          'Please enable location permissions in app settings.',
        );
        await Geolocator.openAppSettings();
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Unable to get current location. Please try again.');
      return null;
    }
  }

  // Load search history from SharedPreferences
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    searchHistory.value = history;
  }

  // Add the search query to history
  Future<void> _addToSearchHistory(String location) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    if (history.contains(location)) {
      history.remove(location); // Remove if already exists
    }
    history.insert(0, location); // Add to the top of the list
    if (history.length > 5) history.removeLast(); // Limit to 5 entries
    await prefs.setStringList('search_history', history);
    searchHistory.value = history;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
