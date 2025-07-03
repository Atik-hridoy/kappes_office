import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_view_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordViewController());
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSize.height(height: 2.0),),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    SizedBox(height: AppSize.height(height: 5.0),),
                    Center(
                      child: AppText(
                        title: AppStaticKey.forgotPassword,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.primary,
                          fontSize: AppSize.height(height: 2.50),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(width: 73.0),
                      child: AppText(
                        title:
                        AppStaticKey
                            .enterTheEmailAssociatedWithYourAccountAndWeWillSendAnEmailWithCodeToResetYourPassword,
                        maxLine: 3,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(letterSpacing: 0.0),
                      ),
                    ),
                    SizedBox(height: AppSize.height(height: 4.0),),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        title: AppStaticKey.emailOrPhone,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(height: AppSize.height(height: 0.5),),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: "Ex : Johndoe@gmail.com",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStaticKey.thisFieldCannotBeEmpty;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSize.height(height: 3.0)),
                    AppCommonButton(
                      onPressed: () async {
                        if (!controller.formKey.currentState!.validate()) {
                          return;
                        }
                        await controller.resetPassword();
                      },
                      title: AppStaticKey.confirm,
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
      ),
    );
  }
}