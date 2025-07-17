import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import '../controllers/data_privacy_view_controller.dart';



class DataPrivacyView extends GetView<DataPrivacyController> {
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
      body: Obx(
            () {
          // Show loading spinner if privacy policy is not yet fetched
          if (controller.privacyPolicy.value.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Use flutter_html to render the HTML content of the privacy policy
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSize.height(height: 2.0)),
              child: Html(  // Use Html widget to render the HTML content
                data: controller.privacyPolicy.value,  // Display the HTML content
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
