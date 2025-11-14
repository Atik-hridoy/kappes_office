import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
              // Handle payment success/failure redirects here if needed
              if (request.url.contains('success') || request.url.contains('cancel')) {
                // Navigate back to success/failure page
                Get.back();
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
      Get.back();
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
          onPressed: () => Get.back(),
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
