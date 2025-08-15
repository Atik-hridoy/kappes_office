import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/profile/widget/profile_with_badge.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/Edit_information_view_controller.dart';

class EditInformationView extends GetView<EditInformationViewController> {
  const EditInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.editInformation,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Skeletonizer(
            enabled: controller.isFetching.value,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Image
                  Center(
                    child: ProfileWithBadge(
                      onPressed: controller.pickImage,
                      imageUrl: controller.imageFile.value != null
                          ? FileImage(controller.imageFile.value!) as ImageProvider
                          : (controller.profileImageUrl.value.isNotEmpty
                              ? NetworkImage(controller.profileImageUrl.value) as ImageProvider
                              : null),
                    ),
                  ),

                  /// Full Name Text
                  Center(
                    child: AppText(
                      title: controller.fullName.value.isNotEmpty
                          ? controller.fullName.value
                          : "User",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// Full Name Field
                  AppText(
                    title: AppStaticKey.fullName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    key: ValueKey('name_${controller.fullName.value}'),
                    initialValue: controller.fullName.value,
                    decoration: const InputDecoration(
                      hintText: AppStaticKey.enterYourFullName,
                    ),
                    onChanged: (value) => controller.fullName.value = value,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// Email Field
                  AppText(
                    title: AppStaticKey.email,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    key: ValueKey('email_${controller.email.value}'),
                    initialValue: controller.email.value,
                    decoration: const InputDecoration(
                      hintText: AppStaticKey.enterYourEmail,
                    ),
                    onChanged: (value) => controller.email.value = value,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// Phone Field
                  AppText(
                    title: AppStaticKey.phoneNumber,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  IntlPhoneField(
                    key: ValueKey('phone_${controller.phone.value}'),
                    initialValue: controller.phone.value,
                    decoration: const InputDecoration(
                      hintText: AppStaticKey.enterYourPhoneNumber,
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'CA',
                    onChanged: (phone) => controller.phone.value = phone.completeNumber,
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// Address Field
                  AppText(
                    title: AppStaticKey.address,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    key: ValueKey('address_${controller.address.value}'),
                    initialValue: controller.address.value,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: AppStaticKey.enterYourAddress,
                    ),
                    onChanged: (value) => controller.address.value = value,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 3.0)),

                  /// ✅ Update Button with loading spinner
                  AppCommonButton(
                    title: controller.isLoading.value ? "Updating..." : AppStaticKey.update,
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.updateProfile();
                      }
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
