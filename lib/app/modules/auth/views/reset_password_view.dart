import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/auth/controllers/reset_password_view_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ResetPasswordView extends GetView<ResetPasswordViewController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordViewController());
    
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSize.height(height: 5.0)),
                  Center(
                    child: AppText(
                      title: AppStaticKey.resetPassword,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                        fontSize: AppSize.height(height: 2.50),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),
                  Center(
                    child: SizedBox(
                      width: AppSize.width(width: 80.0),
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
                  ),

                  SizedBox(height: AppSize.height(height: 3.0)),

                  /// password
                  AppText(
                    title: AppStaticKey.password,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: AppSize.height(height: 0.5)),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordTextEditingController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.createPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                          },
                          child:
                              controller.isPasswordVisible.value
                                  ? const Icon(
                                    Icons.visibility_outlined,
                                    color: AppColors.lightGray,
                                  )
                                  : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: AppColors.lightGray,
                                  ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        } else if (value.length < 8) {
                          return AppStaticKey
                              .passwordMustBeAtLeastEightCharacters;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// confirm password
                  AppText(
                    title: AppStaticKey.confirmNewPassword,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: AppSize.height(height: 0.5)),
                  Obx(
                    () => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.reEnterYourNewPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.isConfirmPasswordVisible.value =
                                !controller.isConfirmPasswordVisible.value;
                          },
                          child:
                              controller.isConfirmPasswordVisible.value
                                  ? const Icon(
                                    Icons.visibility_outlined,
                                    color: AppColors.lightGray,
                                  )
                                  : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: AppColors.lightGray,
                                  ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        } else if (value !=
                            controller.passwordTextEditingController.text) {
                          return AppStaticKey.confirmPasswordIsIncorrect;
                        } else if (value.length < 8) {
                          return AppStaticKey
                              .passwordMustBeAtLeastEightCharacters;
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: AppSize.height(height: 3.0)),
                  Obx(
                    () => AppCommonButton(
                      onPressed: controller.isLoading.value
                          ? () {}
                          : () => controller.resetPassword(),
                      title: controller.isLoading.value ? 'Resetting...' : AppStaticKey.saveChanges,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}