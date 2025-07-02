// File: recommended_product_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/home/recommended_product_service.dart';

class RecommendedProductViewController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final recommendedProducts = <dynamic>[].obs;
  final RecommendedProductService _service = RecommendedProductService();

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedProducts();
  }

  Future<void> fetchRecommendedProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _service.fetchRecommendedProducts();
      if (result['success'] == true) {
        // Adjust this depending on your backend response structure
        final data = result['data'];
        if (data is Map && data.containsKey('result')) {
          recommendedProducts.assignAll(data['result']);
        } else if (data is List) {
          recommendedProducts.assignAll(data);
        } else {
          recommendedProducts.clear();
        }
        errorMessage.value = '';
      } else {
        errorMessage.value = result['message'] ?? 'Something went wrong';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
