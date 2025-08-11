import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';

class SearchLocationViewController extends GetxController {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  Rx<Marker?> selectedMarker = Rx<Marker?>(null);
  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(49.282730, -123.120735), // Default: Vancouver
    zoom: 12,
  );
  final Rx<CameraPosition?> dynamicCameraPosition = Rx<CameraPosition?>(null);

  // List to hold the search history
  RxList<String> searchHistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(onSearchChanged);
    _initCurrentLocation(); // Fetch current location on screen load
    _loadSearchHistory(); // Load search history when the controller is initialized
  }

  // Map created callback
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Handle search input change and attempt to find location (address or coordinates)
  void onSearchChanged() async {
    final input = searchController.text.trim();

    // Skip if input is empty or just a few characters (debounce can also be added for smoother UI)
    if (input.isEmpty) {
      return;
    }

    // Check for coordinates format (lat, long)
    final regex = RegExp(r'^(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)$');
    final match = regex.firstMatch(input);
    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        final pos = LatLng(lat, lng);
        moveToLocation(pos, label: 'Searched Coordinates');
        _addToSearchHistory('$lat, $lng'); // Add the search to history
        return;
      }
    }

    // Try geocoding address
    try {
      final locations = await locationFromAddress(input);
      if (locations.isNotEmpty) {
        final first = locations.first;
        final pos = LatLng(first.latitude, first.longitude);
        moveToLocation(pos, label: 'Search: $input');
        _addToSearchHistory(input); // Add the search to history
      } else {
        // Show snackbar after the search attempt, not on each keystroke
        Get.snackbar("Not Found", "No location found for \"$input\"");
      }
    } catch (e) {
      // Show snackbar after the search attempt
      Get.snackbar("Search Error", "Could not find: $input");
    }
  }

  // Use current location to update map
  Future<void> useCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      moveToLocation(pos, label: 'Current Location');
    }
  }

  // Move camera and update marker on map
  void moveToLocation(LatLng pos, {String label = 'Selected Location'}) {
    mapController?.animateCamera(CameraUpdate.newLatLng(pos));
    selectedMarker.value = Marker(
      markerId: MarkerId('selected'),
      position: pos,
      infoWindow: InfoWindow(title: label),
    );
  }

  // Initialize current location and set initial camera position
  void _initCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      dynamicCameraPosition.value = CameraPosition(target: pos, zoom: 14);
      moveToLocation(pos, label: 'My Location');
    }
  }

  // Fetch the current location of the user
  Future<LatLng?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location Disabled', 'Please enable GPS.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permission is required.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Enable location permission in app settings.',
        );
        await Geolocator.openAppSettings();
        return null;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Unable to get current location.');
      return null;
    }
  }

  // Add search history to shared preferences
  Future<void> _addToSearchHistory(String location) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    if (history.contains(location)) {
      history.remove(location); // Remove the location if it's already there
    }
    history.insert(0, location); // Add the location to the top of the list
    if (history.length > 5) {
      history.removeLast(); // Keep only the last 5 searches
    }
    await prefs.setStringList('search_history', history);
    searchHistory.value = history;
  }

  // Load search history from shared preferences
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    searchHistory.value = history;
  }

  // Handle the confirm location action (passing back selected position)
  void onConfirmLocation() {
    final marker = selectedMarker.value;
    if (marker != null) {
      Get.back(result: marker.position);  // Return the selected position to the previous screen
    } else {
      Get.snackbar("Error", "Please select a location first");
    }
  }

  // Build the map widget
  Widget buildMap() {
    return Obx(() {
      final camPos = dynamicCameraPosition.value ?? initialCameraPosition;
      return GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: camPos,
        markers: selectedMarker.value != null ? {selectedMarker.value!} : {},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
        zoomControlsEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
      );
    });
  }

  // Build search history UI below the map
  Widget buildSearchHistory() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title: "Search History",
            style: Get.textTheme.titleSmall,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final location = searchHistory[index];
              return ListTile(
                title: Text(location),
                onTap: () {
                  // When an item is tapped, move the map to that location
                  final coordinates = location.split(',');
                  if (coordinates.length == 2) {
                    final lat = double.tryParse(coordinates[0].trim());
                    final lng = double.tryParse(coordinates[1].trim());
                    if (lat != null && lng != null) {
                      final pos = LatLng(lat, lng);
                      moveToLocation(pos, label: 'History: $location');
                    }
                  }
                },
              );
            },
          ),
        ],
      );
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
