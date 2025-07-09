import 'dart:io';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/profile/widget/profile_with_badge.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controllers/Edit_information_view_controller.dart';

class EditInformationView extends GetView<EditInformationViewController> {
  const EditInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: AppText(
          title: AppStaticKey.editInformation,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            AppSize.height(height: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(
                      () => ProfileWithBadge(
                    onPressed: () {
                      controller.pickImage();
                    },
                    imageUrl: controller.imageFile.value != null
                        ? FileImage(controller.imageFile.value!)
                        : null,
                  ),
                ),
              ),
              Center(
                child: Obx(
                      () => AppText(
                    title: controller.fullName.value.isNotEmpty
                        ? controller.fullName.value
                        : "Hassan Ali", // You can modify this part
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(height: 1.0)),

              // Full Name
              AppText(
                title: AppStaticKey.fullName,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14.0),
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

              // Email
              AppText(
                title: AppStaticKey.email,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14.0),
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

              // Phone
              AppText(
                title: AppStaticKey.phoneNumber,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
              ),
              IntlPhoneField(
                decoration: const InputDecoration(
                  hintText: AppStaticKey.enterYourPhoneNumber,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
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

              // Address
              AppText(
                title: AppStaticKey.address,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
              ),
              TextFormField(
                maxLines: 3,
                style: const TextStyle(fontSize: 14.0),
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
              SizedBox(height: AppSize.height(height: 1.0)),

              // Update Button
              AppCommonButton(
                onPressed: () => controller.updateProfile(),
                title: AppStaticKey.update,
                fontSize: AppSize.height(height: 1.70),
                backgroundColor: AppColors.primary,
                borderColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
