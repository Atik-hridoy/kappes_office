import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/auth/controllers/verify_otp_view_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
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
              Obx(
                () =>
                    controller.errorMessage.value.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              // Countdown Timer Display
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.height(height: 1.0),
                    horizontal: AppSize.width(width: 4.0),
                  ),
                  decoration: BoxDecoration(
                    color: controller.remaining.value > 0
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: controller.remaining.value > 0
                            ? AppColors.primary
                            : Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        controller.remaining.value > 0
                            ? 'OTP expires in ${controller.formattedTime}'
                            : 'OTP expired',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: controller.remaining.value > 0
                                  ? AppColors.primary
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 2.0)),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            await controller.verifyOtp();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.height(height: 1.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : Text(
                            AppStaticKey.verify,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.5)),
              // Resend OTP Button
              Obx(
                () => TextButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.resendOtp();
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 18,
                        color: controller.isLoading.value
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        controller.remaining.value > 0
                            ? 'Didn\'t receive the code? Resend'
                            : 'Resend OTP',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: controller.isLoading.value
                                  ? Colors.grey
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
