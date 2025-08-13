import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocationViewController extends GetxController {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  RxList<String> searchHistory = <String>[].obs;

  Timer? _debounce;
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(49.282730, -123.120735), // Default location (Vancouver)
    zoom: 12,
  );

  get onConfirmLocation => null;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(onSearchChanged);
    _loadSearchHistory();
    _initCurrentLocation(); // Try to get user's current location when the screen loads
  }

  // Fetch the current location and update map
  Future<void> useCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      moveToLocation(pos, label: 'Current Location');
    }
  }

  // Initialize and move to user's current location
  Future<void> _initCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      moveToLocation(pos, label: 'My Location');
    }
  }

  // Handle search text changes and debounce input
  void onSearchChanged() {
    final input = searchController.text.trim();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () => _handleSearch(input));
  }

  // Handle the search input (address or coordinates)
  void _handleSearch(String input) async {
    if (input.isEmpty) return;

    final coordinatesRegex = RegExp(r'^(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)$');
    final match = coordinatesRegex.firstMatch(input);

    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        moveToLocation(LatLng(lat, lng), label: 'Searched Coordinates');
        _addToSearchHistory('$lat, $lng');
        return;
      }
    }

    // Geocode address if not coordinates
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
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 14));
    selectedMarker.value = Marker(
      markerId: MarkerId('selected'),
      position: pos,
      infoWindow: InfoWindow(title: label),
    );
  }

  // Handle map tap to select a location
  void onMapTap(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = '';
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        address = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country
        ].where((s) => s != null && s.isNotEmpty).join(', ');

        searchController.text = address.isNotEmpty
            ? address
            : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';

        moveToLocation(position, label: address.isNotEmpty ? address : 'Selected Location');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not get address for this location');
    }
  }

  // Add the searched location to the search history
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

  // Load search history from shared preferences
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    searchHistory.value = history;
  }

  // Get user's current location
  Future<LatLng?> _getCurrentLocation() async {
  try {
    // Step 1: Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Disabled', 'Please enable GPS to use location services');
      return null; // Early return if services are not enabled
    }

    // Step 2: Check for location permissions
    LocationPermission permission = await Geolocator.checkPermission();

    // If permissions are denied, request them
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission is required to access your current location');
        return null;
      }
    }

    // If permissions are denied forever, open the app settings
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied Forever',
        'Please enable location permissions in app settings.',
      );
      await Geolocator.openAppSettings();
      return null;
    }

    // Step 3: Get the current location once permission is granted
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    // Return the current location as LatLng
    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    // Catching any errors that might occur and showing appropriate feedback
    Get.snackbar('Error', 'Unable to get current location. Please try again.');
    return null;
  }
}


  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  buildSearchHistory() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final location = searchHistory[index];
              return ListTile(
                title: Text(location),
                onTap: () {
                  searchController.text = location;
                  onSearchChanged();
                },
              );
            },
          ),
        ],
      );
    });
  }
}
