import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TermsConditionsView extends GetView {
  const TermsConditionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.termsAndConditions,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: AppText(
            maxLine: 5000,
            title: """1. Acceptance of Terms
By using The Canuck app, you agree to these Terms & Conditions. If you do not agree, please do not use the app.
2. User Accounts
You may need to create an account to access certain features. Keep your account information secure and notify us of any unauthorized use.
3. Products and Pricing
Prices are listed in CAD and may include taxes and shipping. The Canuck reserves the right to modify prices without notice.
4. Shipping
Shipping costs and delivery times vary. We are not responsible for delays caused by third-party carriers.
5. Returns and Refunds
Return policies are set by individual vendors. Please check the seller’s policy before purchasing.
6. Use of the App
Do not misuse the app or interfere with its functionality. You may not use the app for illegal activities.
7. Intellectual Property
All content in the app is owned by The Canuck or its partners and is protected by copyright.
8. Privacy Policy
Your use of the app is governed by our Privacy Policy, which explains how we handle your data.
9. Limitation of Liability
We are not responsible for any damages, losses, or issues resulting from your use of the app or products.
10. Changes to Terms
We may update these Terms at any time. Check for updates regularly.
11. Contact Us
For questions, contact us at support@thecanuck.com.""",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),

    );
  }
}
