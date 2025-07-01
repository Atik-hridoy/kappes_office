import 'package:canuck_mall/app/dev_data/company_banner_dev_data.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:canuck_mall/app/widgets/custom_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ServicesView extends GetView {
  const ServicesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.height(height: 1.5)),
            CustomSlider(
              onChanged: (value) {},
              length: companyBannerList.length,
              item: companyBannerList,
            ),

            /// our services
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.ourServices,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: """• Interior painting
• Exterior painting
• Commercial painting
• Power washing
• Custom color consultation
• Cabinet and furniture painting""",
            ),
          ],
        ),
      ),
    );
  }
}
