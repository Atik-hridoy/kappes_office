import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DataPrivacyView extends GetView {
  const DataPrivacyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.privacyAndData,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: AppText(
            maxLine: 5000,
            title: """At The Canuck, your privacy is important to us. By using our app, you agree to the following:
Information We Collect: We collect personal details (name, email, payment info) and usage data (app activity, device info) to improve your experience.
How We Use Your Info: Your data helps us process orders, provide customer support, and send updates or promotions.
Sharing Data: We may share your info with trusted third parties for payment processing and shipping. We do not sell your personal data.
Security: We take reasonable steps to protect your data but cannot guarantee complete security.
Your Rights: You can update, correct, or delete your information anytime. You can also opt-out of marketing emails.
Cookies: We use cookies to improve your experience. You can manage cookie preferences in your settings.
Changes: We may update this policy. Any changes will be posted in the app.
For questions, contact us at support@thecanuck.com.""",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),

    );
  }
}
