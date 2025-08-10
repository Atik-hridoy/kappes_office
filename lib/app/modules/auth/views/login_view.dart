import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/auth/widgets/custom_icon_button.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';



class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();


    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSize.height(height: 2.0)),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSize.height(height: 5.0)),
                  Center(
                    child: AppText(
                      title: AppStaticKey.welcomeBack,
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
                      width: AppSize.width(width: 65.0),
                      child: AppText(
                        title:
                            AppStaticKey
                                .logInToContinueShoppingAndEnjoyPersonalizedOffers,
                        maxLine: 3,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(letterSpacing: 0.0),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 3.0)),


                  /// email
                  AppText(
                    title: AppStaticKey.email,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: AppSize.height(height: 0.5)),
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
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// password
                  AppText(
                    title: AppStaticKey.password,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: AppSize.height(height: 0.5)),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
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

                  /// remember me, forgot password, sign in button....
                  SizedBox(height: AppSize.height(height: 2.0)),
                  Row(
                    children: [
                      Obx(
                        () => Transform.scale(
                          scale: 0.8,
                          child: Checkbox(
                            value: controller.isRemember.value,
                            onChanged: (value) {
                              controller.isRemember.value = value ?? false;
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(
                              width: 1.0,
                              color: AppColors.lightGray,
                            ),
                            activeColor: AppColors.primary,
                          ),
                        ),
                      ),
                      AppText(
                        title: AppStaticKey.rememberMe,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.forgotPassword);
                        },
                        child: AppText(
                          title: AppStaticKey.forgotPassword,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),
                  AppCommonButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final success = await controller.login();
                      if (success) {
                        Get.offAllNamed(Routes.bottomNav);
                      } else {
                        Get.snackbar('Login Failed', controller.errorMessage.value,
                            backgroundColor: Colors.red.withValues(alpha: 0.7), colorText: Colors.white);
                      }
                    },
                    title: AppStaticKey.singIn,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  AppText(
                    title: AppStaticKey.or,
                    style: Theme.of(context).textTheme.titleSmall,
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
                                    Get.offAllNamed(Routes.signUP);
                                  },
                            text: AppStaticKey.createAccount,
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