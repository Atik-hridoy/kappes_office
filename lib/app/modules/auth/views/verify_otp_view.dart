import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/auth/controllers/verify_otp_view_controller.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpView extends GetView<VerifyOtpViewController> {
  const VerifyOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Column(
            children: [
              SizedBox(height: AppSize.height(height: 5.0)),
              Center(
                child: AppText(
                  title: AppStaticKey.verifyOTP,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.primary,
                    fontSize: AppSize.height(height: 2.50),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              SizedBox(
                width: AppSize.width(width: 73.0),
                child: AppText(
                  title:
                      AppStaticKey
                          .enterYourOTPWhichHasBeenSentToYourEmailAndCompletelyVerifyYourAccount,
                  maxLine: 3,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(letterSpacing: 0.0),
                ),
              ),
              SizedBox(height: AppSize.height(height: 4.0)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.height(height: 2.0),
                ),
                child: PinCodeTextField(
                  length: 4,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.primary,
                  textStyle: Theme.of(context).textTheme.titleLarge,
                  appContext: context,
                  onChanged: (value) {
                    controller.otpCode.value = value;
                  },
                ),
              ),
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SizedBox.shrink()),
              SizedBox(height: AppSize.height(height: 3.0)),
              AppCommonButton(
                onPressed: () async {
                  final args = Get.arguments;
                  if (args is Map && args['email'] != null) {
                    controller.email.value = args['email'];
                  }
                  await controller.verifyOtp();
                },
                title: AppStaticKey.verify,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
