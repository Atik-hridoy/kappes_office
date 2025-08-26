import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/auth/controllers/login_controller.dart';
import 'package:canuck_mall/app/modules/auth/widgets/custom_icon_button.dart';
import 'package:canuck_mall/app/widgets/dialogs/error_dialog.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key}) {
    Get.put(LoginController());
  }
  
  final _formKey = GlobalKey<FormState>();
  BuildContext get context => Get.context!;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                _buildEmailField(),
                _buildPasswordField(),
                _buildRememberMeRow(),
                _buildLoginButton(),
                _buildSocialLogin(),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Column(
        children: [
          AppText(
            title: AppStaticKey.welcomeBack,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.primary,
              fontSize: AppSize.height(height: 2.50),
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: AppSize.height(height: 2.0)),
          AppText(
            title: AppStaticKey.logInToContinueShoppingAndEnjoyPersonalizedOffers,
            maxLine: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: const Color(0xFF696969),
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 1.5, // Increased from 1.5 to 2.0 for better spacing
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title: AppStaticKey.email, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: AppSize.height(height: 1.5)),
        TextFormField(
          controller: controller.emailController,
          decoration: InputDecoration(hintText: AppStaticKey.enterYourEmailAddress),
          validator: (value) => value!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) 
            ? AppStaticKey.enterAValidEmail : null,
        ),
        SizedBox(height: AppSize.height(height: 2.0)),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title: AppStaticKey.password, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: AppSize.height(height: 1.5)),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          decoration: InputDecoration(
            hintText: AppStaticKey.enterPassword,
            suffixIcon: InkWell(
              onTap: () => controller.isPasswordVisible.value = !controller.isPasswordVisible.value,
              child: Icon(
                controller.isPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.lightGray,
              ),
            ),
          ),
          validator: (value) => value!.isEmpty || value.length < 8 ? AppStaticKey.passwordMustBeAtLeastEightCharacters : null,
        )),
        SizedBox(height: AppSize.height(height: 2.0)),
      ],
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        Obx(() => Checkbox(
          value: controller.isRemember.value,
          onChanged: (value) => controller.isRemember.value = value ?? false,
          activeColor: AppColors.primary,
        )),
        AppText(title: AppStaticKey.rememberMe, style: Theme.of(context).textTheme.bodySmall),
        Spacer(),
        InkWell(
          onTap: () => Get.toNamed(Routes.forgotPassword),
          child: AppText(title: AppStaticKey.forgotPassword, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.primary)),
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _performLogin();
    }
  }

  Future<void> _performLogin() async {
    final success = await controller.login();
    if (success) {
      Get.offAllNamed(Routes.bottomNav);
    } else if (controller.errorMessage.value.isNotEmpty) {
      ErrorDialog.show(
        title: 'Login Failed',
        message: controller.errorMessage.value,
        buttonText: 'OK',
      );
    }
  }

  Widget _buildLoginButton() {
    return Obx(
      () => AppCommonButton(
        onPressed: controller.isLoading.value 
            ? () {} // Empty callback when loading
            : () => _handleLogin(), // Wrapped in a non-nullable function
        title: controller.isLoading.value ? 'Signing in...' : AppStaticKey.signIn,
        style: Get.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        SizedBox(height: AppSize.height(height: 1.0)),
        AppText(title: AppStaticKey.or, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: AppSize.height(height: 1.0)),
        CustomIconButton(onPressed: () {}, isInProgress: false, path: AppIcons.google, title: AppStaticKey.continueWithGoogle),
        SizedBox(height: AppSize.height(height: 2.0)),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppStaticKey.haveAnAccount,
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => Get.offAllNamed(Routes.signUP),
              text: AppStaticKey.createAccount,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
