import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  
  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              print('🌐 [PaymentWebView] Navigation request: ${request.url}');
              
              // Handle Stripe payment completion - check for various success indicators
              if (request.url.contains('success') || 
                  request.url.contains('payment_intent_client_secret') ||
                  request.url.contains('setup_intent_client_secret') ||
                  request.url.contains('payment_method') ||
                  request.url.toLowerCase().contains('complete') ||
                  request.url.toLowerCase().contains('confirm') ||
                  request.url.contains('redirect_status=succeeded') ||
                  request.url.contains('payment_status=paid') ||
                  (request.url.contains('stripe.com') && request.url.contains('success'))) {
                
                print('✅ [PaymentWebView] Payment completed, redirecting to success page');
                
                // Navigate to success page with payment completion
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.offAllNamed(Routes.checkoutSuccessfulView);
                  });
                }
                return NavigationDecision.prevent;
              }
              
              // Handle payment cancellation/failure
              if (request.url.contains('cancel') || 
                  request.url.contains('error') ||
                  request.url.contains('failed')) {
                
                print('❌ [PaymentWebView] Payment cancelled/failed');
                
                // Go back to checkout with error message
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.back();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment was cancelled or failed. Please try again.'),
                        ),
                      );
                    }
                  });
                }
                return NavigationDecision.prevent;
              }
              
              return NavigationDecision.navigate;
            },
            onWebResourceError: (WebResourceError error) {
              print('WebView error: ${error.description}');
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } catch (e) {
      print('Error initializing WebView: $e');
      // Fallback: close the WebView if initialization fails
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.back();
        });
      }
    }
  }

  @override
  void dispose() {
    // Clear controller safely
    try {
      // Don't call controller methods in dispose to avoid platform channel errors
    } catch (e) {
      print('Error disposing WebView: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog before closing payment
            if (mounted && context.mounted) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Cancel Payment'),
                    content: const Text('Are you sure you want to cancel the payment?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(), // Close dialog
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(); // Close payment webview
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Payment was cancelled by user.'),
                            ),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
