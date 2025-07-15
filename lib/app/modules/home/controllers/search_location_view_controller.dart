import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class SearchLocationViewController extends GetxController {
  // Google Maps controller
  GoogleMapController? mapController;

  // Search text controller
  TextEditingController searchController = TextEditingController();

  // Marker for selected location
  Rx<Marker?> selectedMarker = Rx<Marker?>(null);

  // Initial camera position (example: Vancouver)
  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(49.282730, -123.120735),
    zoom: 12,
  );

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(onSearchChanged);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onSearchChanged() async {
    final text = searchController.text;
    if (text.isEmpty) {
      return;
    }
    searchAndMove();
  }

  void searchAndMove() {
    final input = searchController.text.trim();
    final regex = RegExp(r'^(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)$');
    final match = regex.firstMatch(input);
    if (match != null) {
      final lat = double.tryParse(match.group(1)!);
      final lng = double.tryParse(match.group(2)!);
      if (lat != null && lng != null) {
        final pos = LatLng(lat, lng);
        mapController?.animateCamera(CameraUpdate.newLatLng(pos));
        selectedMarker.value = Marker(
          markerId: MarkerId('selected'),
          position: pos,
          infoWindow: InfoWindow(title: 'Selected Location'),
        );
      }
    } else {
      Get.snackbar('Invalid Input', 'Enter coordinates as: latitude, longitude');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}