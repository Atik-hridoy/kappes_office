import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AboutUsView extends GetView {
  const AboutUsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.aboutUs,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: AppText(
              maxLine: 5000,
              title: """At The Canuck, we're passionate about bringing the best of Canada right to your fingertips. Whether you're shopping by province or exploring unique regional treasures, we connect you with top-quality products from local vendors across the country. Our mission is to provide a seamless shopping experience that celebrates the diverse landscapes, cultures, and craftsmanship found from coast to coast. Shop with us and discover Canadian excellence, wherever you are!""",
              style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),

    );
  }
}
