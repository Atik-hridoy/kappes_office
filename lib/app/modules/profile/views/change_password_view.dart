import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/profile/controllers/change_password_view_controller.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChangePasswordView extends GetView<ChangePasswordViewController>{
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.changePassword,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            AppSize.height(height: 2.0),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// current password field
                AppText(title: AppStaticKey.currentPassword, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),),
                SizedBox(height: AppSize.height(height: 0.5),),
                Obx(
                      () => TextFormField(
                      controller: controller.currentPasswordTextEditingController,
                      obscureText: !controller.isCurrentPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.currentPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.isCurrentPasswordVisible.value =
                            !controller.isCurrentPasswordVisible.value;
                          },
                          child: controller.isCurrentPasswordVisible.value
                              ? const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.gray,
                          )
                              : const Icon(
                            Icons.visibility_off_outlined,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        } else if (value.length < 8) {
                          return AppStaticKey
                              .passwordMustBeAtLeastEightCharacters;
                        }
                        return null;
                      }
                  ),
                ),

                SizedBox(height: AppSize.height(height: 2.0),),
                /// create password field
                AppText(title: AppStaticKey.newPassword, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),),
                SizedBox(height: AppSize.height(height: 0.5),),
                Obx(
                      () => TextFormField(
                      controller: controller.createPasswordTextEditingController,
                      obscureText: !controller.isCreatePasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.newPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.isCreatePasswordVisible.value =
                            !controller.isCreatePasswordVisible.value;
                          },
                          child: controller.isCreatePasswordVisible.value
                              ? const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.gray,
                          )
                              : const Icon(
                            Icons.visibility_off_outlined,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        } else if (value.length < 8) {
                          return AppStaticKey
                              .passwordMustBeAtLeastEightCharacters;
                        }
                        return null;
                      }
                  ),
                ),

                SizedBox(height: AppSize.height(height: 2.0),),

                /// confirm password field
                AppText(title: AppStaticKey.confirmPassword, style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),),
                SizedBox(height: AppSize.height(height: 0.5),),
                Obx(
                      () => TextFormField(
                      controller: controller.confirmPasswordTextEditingController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.confirmPassword,
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.isConfirmPasswordVisible.value =
                            !controller.isConfirmPasswordVisible.value;
                          },
                          child: controller.isConfirmPasswordVisible.value
                              ? const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.gray,
                          )
                              : const Icon(
                            Icons.visibility_off_outlined,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        } else if(value != controller.createPasswordTextEditingController.text){
                          return AppStaticKey.confirmPasswordIsIncorrect;
                        }else if(value.length < 8){
                          return AppStaticKey
                              .passwordMustBeAtLeastEightCharacters;
                        }
                        return null;
                      }
                  ),
                ),

                SizedBox(
                  height: AppSize.height(height: 3.0),
                ),
                AppCommonButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await controller.changePassword();
                    }
                  },
                  title: AppStaticKey.update,
                  backgroundColor: AppColors.primary,
                  fontSize: AppSize.height(height: 1.70),
                  borderColor: AppColors.primary,

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
