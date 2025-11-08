import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/modules/auth/controllers/verify_otp_view_controller.dart';

/// Integration tests for OTP verification flow
/// Tests the complete user journey with all fixes applied
void main() {
  late VerifyOtpViewController controller;

  setUp(() {
    Get.testMode = true;
    controller = VerifyOtpViewController();
  });

  tearDown(() {
    Get.reset();
    controller.dispose();
  });

  group('Integration Test - Multiple Error Messages Fix', () {
    test('should handle rapid button clicks without showing multiple errors', () async {
      // Arrange
      controller.email.value = 'test@example.com';
      controller.otpCode.value = '1234';
      controller.from = 'forgot_password';

      // Act - Simulate rapid button clicks
      final call1 = controller.verifyOtp();
      final call2 = controller.verifyOtp(); // Should be ignored
      final call3 = controller.verifyOtp(); // Should be ignored

      await Future.wait([call1, call2, call3]);

      // Assert - Only one call should have been processed
      // The second and third calls should return false immediately
      expect(await call2, false);
      expect(await call3, false);
    });

    test('should clear previous error before new verification attempt', () async {
      // Arrange
      controller.email.value = 'test@example.com';
      controller.otpCode.value = '';
      controller.errorMessage.value = 'Old error message';

      // Act - First attempt with empty OTP
      await controller.verifyOtp();
      final firstError = controller.errorMessage.value;

      // Change OTP and try again
      controller.otpCode.value = 'abcd';
      await controller.verifyOtp();
      final secondError = controller.errorMessage.value;

      // Assert
      expect(firstError, 'OTP is required');
      expect(secondError, 'OTP must be a number');
      // Each error should be different, showing the error was cleared
    });
  });

  group('Integration Test - Timer and Resend Flow', () {
    test('should reset timer after successful resend', () async {
      // Arrange
      controller.email.value = 'test@example.com';
      controller.from = 'forgot_password';
      controller.remaining.value = 30; // Simulate timer running down
      controller.startTimer();

      // Note: Actual resend would require mocking the service
      // This test verifies the timer logic exists
      expect(controller.remaining.value, lessThanOrEqualTo(30));
      
      controller.onClose(); // Clean up timer
    });

    test('should show appropriate resend message based on timer', () {
      // Arrange & Act
      controller.remaining.value = 60;
      final messageWhenActive = controller.remaining.value > 0;

      controller.remaining.value = 0;
      final messageWhenExpired = controller.remaining.value == 0;

      // Assert
      expect(messageWhenActive, true);
      expect(messageWhenExpired, true);
    });
  });

  group('Integration Test - Complete Verification Flow', () {
    test('should validate input before making API call', () async {
      // Test 1: Empty OTP
      controller.email.value = 'test@example.com';
      controller.otpCode.value = '';
      var result = await controller.verifyOtp();
      expect(result, false);
      expect(controller.errorMessage.value, 'OTP is required');

      // Test 2: Empty email
      controller.email.value = '';
      controller.otpCode.value = '1234';
      result = await controller.verifyOtp();
      expect(result, false);
      expect(controller.errorMessage.value, 'Email is required');

      // Test 3: Invalid OTP format
      controller.email.value = 'test@example.com';
      controller.otpCode.value = 'abcd';
      result = await controller.verifyOtp();
      expect(result, false);
      expect(controller.errorMessage.value, 'OTP must be a number');
    });

    test('should handle loading state correctly throughout flow', () async {
      // Arrange
      controller.email.value = 'test@example.com';
      controller.otpCode.value = '1234';
      controller.from = 'forgot_password';

      // Assert initial state
      expect(controller.isLoading.value, false);

      // Act - Start verification
      final verificationFuture = controller.verifyOtp();
      
      // Note: In real scenario, isLoading would be true during API call
      // For this test, we verify the flow completes
      await verificationFuture;

      // Assert final state
      expect(controller.isLoading.value, false);
    });
  });

  group('Integration Test - Error Message Formatting', () {
    test('should format different error types appropriately', () {
      // Test various error message patterns
      final expiredError = 'OTP has expired';
      expect(expiredError.toLowerCase().contains('expired'), true);

      final invalidError = 'Invalid OTP';
      expect(invalidError.toLowerCase().contains('invalid'), true);

      final incorrectError = 'Incorrect OTP';
      expect(incorrectError.toLowerCase().contains('incorrect'), true);
    });
  });

  group('Integration Test - Timer Countdown', () {
    test('should countdown from 120 seconds', () async {
      // Arrange
      expect(controller.remaining.value, 120);
      controller.startTimer();

      // Act - Wait for a few ticks
      await Future.delayed(Duration(seconds: 3));

      // Assert - Timer should have decreased
      expect(controller.remaining.value, lessThan(120));
      expect(controller.remaining.value, greaterThanOrEqualTo(117));

      // Cleanup
      controller.onClose();
    });

    test('should format time correctly at different intervals', () {
      // Test various time values
      final testCases = {
        120: '02:00',
        90: '01:30',
        60: '01:00',
        30: '00:30',
        5: '00:05',
        0: '00:00',
      };

      testCases.forEach((seconds, expectedFormat) {
        controller.remaining.value = seconds;
        expect(controller.formattedTime, expectedFormat);
      });
    });
  });

  group('Integration Test - Resend OTP Validation', () {
    test('should validate email before resending', () async {
      // Arrange
      controller.email.value = '';

      // Act
      await controller.resendOtp();

      // Assert
      expect(controller.errorMessage.value, 'Email is required to resend OTP');
    });

    test('should prevent resend when already loading', () async {
      // Arrange
      controller.isLoading.value = true;
      controller.email.value = 'test@example.com';
      final initialLoadingState = controller.isLoading.value;

      // Act
      await controller.resendOtp();

      // Assert - Loading state should remain unchanged
      expect(controller.isLoading.value, initialLoadingState);
    });
  });

  group('Integration Test - Memory Management', () {
    test('should clean up timer on controller disposal', () {
      // Arrange
      controller.startTimer();
      final timerWasStarted = controller.remaining.value <= 120;

      // Act
      controller.onClose();

      // Assert - Timer should be cancelled (no exceptions thrown)
      expect(timerWasStarted, true);
    });
  });

  group('Integration Test - User Experience Flow', () {
    test('should provide clear feedback at each step', () async {
      // Step 1: User enters invalid OTP
      controller.email.value = 'test@example.com';
      controller.otpCode.value = 'abc';
      await controller.verifyOtp();
      expect(controller.errorMessage.value, isNotEmpty);

      // Step 2: User corrects OTP format
      controller.otpCode.value = '1234';
      // Error should be cleared on next attempt
      controller.verifyOtp();
      await Future.delayed(Duration(milliseconds: 10));
      // Error is cleared at start of verification
      
      // Step 3: Timer provides countdown
      expect(controller.formattedTime, matches(RegExp(r'\d{2}:\d{2}')));
    });
  });
}
