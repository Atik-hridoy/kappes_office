import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/data/netwok/trade_service/trade_service.dart';

class CompanyDetailsController extends GetxController {
  late Business business;
  bool isLoading = true;
  String? errorMessage;
  bool isSendingMessage = false;
  
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    _initializeBusiness();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
  
  void _initializeBusiness() {
    try {
      final args = Get.arguments;
      if (args is Business) {
        business = args;
        isLoading = false;
        update();
      } else {
        // Try to get business ID from parameters and fetch fresh data
        final businessId = Get.parameters['id'];
        if (businessId != null) {
          fetchBusinessById(businessId);
        } else {
          errorMessage = 'Business information not available';
          isLoading = false;
          update();
        }
      }
    } catch (e) {
      errorMessage = 'Error loading business details';
      isLoading = false;
      update();
    }
  }
  
  Future<void> fetchBusinessById(String businessId) async {
    try {
      isLoading = true;
      update();
      
      final fetchedBusiness = await TradeService.getBusinessById(businessId);
      business = fetchedBusiness;
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load business details';
    } finally {
      isLoading = false;
      update();
    }
  }
  
  void _showSnackBar(String title, String message) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  
  Future<void> sendMessage() async {
    // Validate form
    if (nameController.text.trim().isEmpty) {
      _showSnackBar('Error', 'Please enter your name');
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      _showSnackBar('Error', 'Please enter your email');
      return;
    }
    
    if (messageController.text.trim().isEmpty) {
      _showSnackBar('Error', 'Please enter your message');
      return;
    }
    
    try {
      isSendingMessage = true;
      update();
      
      final success = await TradeService.sendMessageToBusiness(
        business.id,
        message: messageController.text.trim(),
        senderName: nameController.text.trim(),
        senderEmail: emailController.text.trim(),
      );
      
      if (success) {
        // Clear form
        nameController.clear();
        emailController.clear();
        messageController.clear();
        
        _showSnackBar('Success', 'Message sent successfully!');
      } else {
        _showSnackBar('Error', 'Failed to send message. Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error', 'Failed to send message. Please try again.');
    } finally {
      isSendingMessage = false;
      update();
    }
  }
}
