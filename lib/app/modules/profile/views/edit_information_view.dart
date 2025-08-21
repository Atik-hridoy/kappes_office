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

class EditInformationView extends StatefulWidget {
  const EditInformationView({super.key});

  @override
  State<EditInformationView> createState() => _EditInformationViewState();
}

class _EditInformationViewState extends State<EditInformationView> {
  final EditInformationViewController controller = Get.find<EditInformationViewController>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    
    _nameController = TextEditingController(text: controller.fullName.value);
    _emailController = TextEditingController(text: controller.email.value);
    // Remove country code for display
    final phoneNumber = controller.phone.value.replaceAll(RegExp(r'^\+?\d+\s*'), '');
    _phoneController = TextEditingController(text: phoneNumber);
    _addressController = TextEditingController(text: controller.address.value);
    
    // Update controllers when values change from the controller
    ever(controller.fullName, (value) {
      if (_nameController.text != value) {
        _nameController.text = value;
      }
    });
    
    ever(controller.email, (value) {
      if (_emailController.text != value) {
        _emailController.text = value;
      }
    });
    
    ever(controller.phone, (value) {
      if (_phoneController.text != value) {
        _phoneController.text = value;
      }
    });
    
    ever(controller.address, (value) {
      if (_addressController.text != value) {
        _addressController.text = value;
      }
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

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
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.all(AppSize.height(height: 2.0)),
          child: Skeletonizer(
            enabled: controller.isFetching.value,
            child: Form(
              key: _formKey,
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
                    key: ValueKey('name_field'),
                    controller: _nameController,
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
                    key: ValueKey('email_field'),
                    controller: _emailController,
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
                    key: ValueKey('phone_field'),
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: AppStaticKey.enterYourPhoneNumber,
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'CA',
                    disableAutoFillHints: true,
                    disableLengthCheck: true,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (phone) {
                      if (phone.number.isNotEmpty) {
                        controller.phone.value = phone.completeNumber;
                        // Update the controller text without the country code for display
                        _phoneController.text = phone.number;
                      } else {
                        controller.phone.value = '';
                      }
                    },
                    validator: (value) {
                      if (value == null || value.number.trim().isEmpty) {
                        return AppStaticKey.thisFieldCannotBeEmpty;
                      }
                      return null;
                    },
                    onSaved: (phone) {
                      if (phone != null) {
                        controller.phone.value = phone.completeNumber;
                        _phoneController.text = phone.number; // Update display text
                      }
                    },
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),

                  /// Address Field
                  AppText(
                    title: AppStaticKey.address,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    key: ValueKey('address_field'),
                    controller: _addressController,
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
                      if (_formKey.currentState!.validate()) {
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