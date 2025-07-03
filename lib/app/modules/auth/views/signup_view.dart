import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/auth/controllers/sign_up_view_controller.dart';
import 'package:canuck_mall/app/modules/auth/widgets/custom_icon_button.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpView extends GetView<SignUpViewController> {
  const SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AppText(
                      title: AppStaticKey.createYourAccount,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                        fontSize: AppSize.height(height: 2.50),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  Center(
                    child: SizedBox(
                      width: AppSize.width(width: 70.0),
                      child: AppText(
                        title:
                        AppStaticKey
                            .joinUsToExploreTopCanadianMadeProductsExclusiveDealsAndGreatRewards,
                        maxLine: 3,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(letterSpacing: 0.0),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// full name
                  AppText(
                    title: AppStaticKey.fullName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextFormField(
                    controller: controller.fullNameController,
                    decoration: InputDecoration(
                      hintText: AppStaticKey.enterYourFullName,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),

                  /// email
                  AppText(
                    title: AppStaticKey.email,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: AppStaticKey.enterYourEmailAddress,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return AppStaticKey.enterAValidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),

                  /// phone
                  AppText(
                    title: AppStaticKey.phone,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IntlPhoneField(
                      decoration: const InputDecoration(
                        hintText: AppStaticKey.enterYourPhoneNumber,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'CA',
                      onChanged: (phone) {},
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        }
                        return null;
                      }
                  ),

                  /// password
                  AppText(
                    title: AppStaticKey.password,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Obx(
                        () => TextFormField(
                          controller: controller.passwordTextEditingController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.enterPassword,
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
                  SizedBox(height: AppSize.height(height: 1.0)),

                  /// confirm password
                  AppText(
                    title: AppStaticKey.confirmPassword,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Obx(
                        () => TextFormField(
                          controller: controller.confirmPasswordIsIncorrect,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: AppStaticKey.enterPassword,
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

                  /// remember me, forgot password, sign in button....
                  SizedBox(height: AppSize.height(height: 3.0)),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return AppCommonButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        await controller.signUp();
                      },
                      title: AppStaticKey.signUp,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    );
                  }),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  Center(
                    child: AppText(
                      title: AppStaticKey.or,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  CustomIconButton(
                    onPressed: () {},
                    isInProgress: false,
                    path: AppIcons.google,
                    title: AppStaticKey.continueWithGoogle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppStaticKey.haveAnAccount,
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                            recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAllNamed(Routes.login);
                              },
                            text: AppStaticKey.singIn,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: AppColors.primary,
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
        ),
      ),
    );
  }
}
