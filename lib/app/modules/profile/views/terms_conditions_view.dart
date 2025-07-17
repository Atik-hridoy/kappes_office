import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import '../controllers/terms_condition_view_controller.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Manually inject the controller
    final TermsConditionsController controller = Get.put(TermsConditionsController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.termsAndConditions,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(
            () {
          // Show loading spinner if terms and conditions are not yet fetched
          if (controller.termsConditions.value.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Use flutter_html to render the HTML content of the terms and conditions
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              child: Html(
                data: controller.termsConditions.value,  // Display the HTML content
                style: {
                  "p": Style(fontSize: FontSize(16.0)),  // Style paragraphs
                  "h1": Style(fontSize: FontSize(22.0)), // Style headers
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
