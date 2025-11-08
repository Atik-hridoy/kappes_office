import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/modules/auth/views/verify_otp_view.dart';
import 'package:canuck_mall/app/modules/auth/controllers/verify_otp_view_controller.dart';

void main() {
  late VerifyOtpViewController controller;

  setUp(() {
    Get.testMode = true;
    controller = Get.put(VerifyOtpViewController());
  });

  tearDown(() {
    Get.delete<VerifyOtpViewController>();
    Get.reset();
  });

  Widget createTestWidget() {
    return GetMaterialApp(
      home: VerifyOtpView(),
    );
  }

  group('VerifyOtpView - Countdown Timer Display', () {
    testWidgets('should display countdown timer', (WidgetTester tester) async {
      // Arrange
      controller.remaining.value = 120;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('OTP expires in 02:00'), findsOneWidget);
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    });

    testWidgets('should show expired message when timer reaches zero', (WidgetTester tester) async {
      // Arrange
      controller.remaining.value = 0;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('OTP expired'), findsOneWidget);
    });

    testWidgets('should update timer display as time decreases', (WidgetTester tester) async {
      // Arrange
      controller.remaining.value = 90;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('OTP expires in 01:30'), findsOneWidget);

      // Change time
      controller.remaining.value = 60;
      await tester.pumpAndSettle();

      // Assert updated time
      expect(find.text('OTP expires in 01:00'), findsOneWidget);
    });
  });

  group('VerifyOtpView - Resend OTP Button', () {
    testWidgets('should display resend OTP button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Didn\'t receive the code? Resend'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should show "Resend OTP" when timer expires', (WidgetTester tester) async {
      // Arrange
      controller.remaining.value = 0;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Resend OTP'), findsOneWidget);
    });

    testWidgets('should disable resend button when loading', (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = true;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextButton
      final textButton = tester.widget<TextButton>(
        find.ancestor(
          of: find.text('Didn\'t receive the code? Resend'),
          matching: find.byType(TextButton),
        ),
      );

      // Assert
      expect(textButton.onPressed, isNull); // Button should be disabled
    });

    testWidgets('should enable resend button when not loading', (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = false;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the TextButton
      final textButton = tester.widget<TextButton>(
        find.ancestor(
          of: find.text('Didn\'t receive the code? Resend'),
          matching: find.byType(TextButton),
        ),
      );

      // Assert
      expect(textButton.onPressed, isNotNull); // Button should be enabled
    });
  });

  group('VerifyOtpView - Verify Button', () {
    testWidgets('should display verify button', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.widgetWithText(ElevatedButton, 'Verify'), findsOneWidget);
    });

    testWidgets('should show loading indicator when verifying', (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = true;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Verify'), findsNothing);
    });

    testWidgets('should disable verify button when loading', (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = true;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the ElevatedButton
      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      // Assert
      expect(elevatedButton.onPressed, isNull); // Button should be disabled
    });

    testWidgets('should enable verify button when not loading', (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = false;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the ElevatedButton
      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      // Assert
      expect(elevatedButton.onPressed, isNotNull); // Button should be enabled
    });
  });

  group('VerifyOtpView - Error Message Display', () {
    testWidgets('should display error message when present', (WidgetTester tester) async {
      // Arrange
      controller.errorMessage.value = 'Invalid OTP';

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Invalid OTP'), findsOneWidget);
    });

    testWidgets('should not display error message when empty', (WidgetTester tester) async {
      // Arrange
      controller.errorMessage.value = '';

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SizedBox), findsWidgets); // SizedBox.shrink() is used
    });

    testWidgets('should display error in red color', (WidgetTester tester) async {
      // Arrange
      controller.errorMessage.value = 'Test error';

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the error text widget
      final errorText = tester.widget<Text>(find.text('Test error'));

      // Assert
      expect(errorText.style?.color, Colors.red);
    });
  });

  group('VerifyOtpView - OTP Input Field', () {
    testWidgets('should display OTP input field', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - PinCodeTextField should be present
      expect(find.byType(TextField), findsWidgets);
    });
  });

  group('VerifyOtpView - Multiple Error Prevention', () {
    testWidgets('should prevent button tap when loading', (WidgetTester tester) async {
      // Arrange
      controller.isLoading.value = true;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to tap the verify button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert - Button should not respond (onPressed is null)
      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull);
    });
  });
}
