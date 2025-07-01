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
                  textStyle: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 55,
                    fieldWidth: 55,
                    activeColor: Colors.grey.shade200,
                    selectedColor: AppColors.primary,
                    inactiveColor: Colors.grey.shade200,
                    activeFillColor: AppColors.white,
                    selectedFillColor: AppColors.white,
                    inactiveFillColor: AppColors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  // controller: textEditingController,
                  onCompleted: (v) {
                    // print("Completed");
                  },
                  onChanged: (value) {
                    // print(value);
                  },
                  beforeTextPaste: (text) {
                    // print("Allowing to paste $text");
                    return true;
                  },
                  appContext: context,
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),
              AppText(
                title: AppStaticKey.codeHasBeenSentToYourEmail,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Obx(
                () => AppText(
                  title: "${AppStaticKey.resendIn} ${controller.formattedTime}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 3.0)),
              AppCommonButton(
                onPressed: () {
                  Get.toNamed(Routes.resetPassword);
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
