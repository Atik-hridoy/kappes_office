import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_image/app_image.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CompanyAboutUsView extends GetView {
  const CompanyAboutUsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSize.height(height: 1.5)),
            AppText(
              title:
                  """Fresh Painting is a professional painting company that offers high-quality interior and exterior painting services for both residential and commercial properties. They are dedicated to enhancing the aesthetic appeal of your space with precision and attention to detail.""",
              maxLine: 1000,
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.businessHour,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: """• Monday: 9:00 AM - 6:00 PM
        • Tuesday: 9:00 AM - 6:00 PM
        • Wednesday: 9:00 AM - 6:00 PM
        • Thurseday:9:00 AM - 6:00 PM
        • Friday:9:00 AM - 6:00 PM
        • Saturday: 10:00 AM - 4:00 PM
        • Sunday Closed""",
            ),
            SizedBox(height: AppSize.height(height: 2.0)),
            AppText(
              title: AppStaticKey.followUsOnSocialMedia,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: AppSize.height(height: 1.5)),
            Row(
              spacing: AppSize.width(width: 2.0),
              children: [
                AppImage(
                  imagePath: AppIcons.facebookIcon,
                  height: AppSize.height(height: 2.5),
                  width: AppSize.height(height: 2.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
                AppImage(
                  imagePath: AppIcons.instagramIcon,
                  height: AppSize.height(height: 2.5),
                  width: AppSize.height(height: 2.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
                AppImage(
                  imagePath: AppIcons.youtubeIcon,
                  height: AppSize.height(height: 2.5),
                  width: AppSize.height(height: 2.5),
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: AppColors.error);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
