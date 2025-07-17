import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SearchLocationViewController extends GetxController {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();
  Rx<Marker?> selectedMarker = Rx<Marker?>(null);

  final Rx<MapType> mapType = MapType.normal.obs;

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(49.282730, -123.120735), // Default: Vancouver
    zoom: 12,
  );

  final Rx<CameraPosition?> dynamicCameraPosition = Rx<CameraPosition?>(null);

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(onSearchChanged);
    _initCurrentLocation(); // ✅ Fetch current location on screen load
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void toggleMapType() {
    mapType.value = mapType.value == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  void onSearchChanged() async {
    final input = searchController.text.trim();

    // Check for coordinates
    final regex = RegExp(r'^(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)$');
    final match = regex.firstMatch(input);
    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        final pos = LatLng(lat, lng);
        moveToLocation(pos, label: 'Searched Coordinates');
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
      } else {
        Get.snackbar("Not Found", "No location found for \"$input\"");
      }
    } catch (e) {
      Get.snackbar("Search Error", "Could not find: $input");
      print("Geocoding error: $e");
    }
  }

  Future<void> useCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      moveToLocation(pos, label: 'Current Location');
    }
  }

  void moveToLocation(LatLng pos, {String label = 'Selected Location'}) {
    mapController?.animateCamera(CameraUpdate.newLatLng(pos));
    selectedMarker.value = Marker(
      markerId: MarkerId('selected'),
      position: pos,
      infoWindow: InfoWindow(title: label),
    );
  }

  void _initCurrentLocation() async {
    final pos = await _getCurrentLocation();
    if (pos != null) {
      dynamicCameraPosition.value = CameraPosition(target: pos, zoom: 14);
      moveToLocation(pos, label: 'My Location');
    }
  }

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
      );

      return LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      print("Location error: $e");
      Get.snackbar('Error', 'Unable to get current location.');
      return null;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
