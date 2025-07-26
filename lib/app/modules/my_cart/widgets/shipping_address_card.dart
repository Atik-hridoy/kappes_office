import 'package:canuck_mall/app/constants/app_icons.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/checkout_view_controller.dart';
import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.height(height: 1.5)),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.height(height: 1.0)),
                topRight: Radius.circular(AppSize.height(height: 1.0)),
              ),
            ),
            child: Row(
              children: [
                ImageIcon(
                  AssetImage(AppIcons.home),
                  size: AppSize.height(height: 3.0),
                  color: AppColors.white,
                ),
                SizedBox(width: AppSize.width(width: 2.0)),
                AppText(
                  title: AppStaticKey.shippingAddress,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: AppSize.height(height: 2.0),
                    color: AppColors.white,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    final controller = Get.find<CheckoutViewController>();
                    final nameController = TextEditingController(
                      text: controller.userName.value,
                    );
                    final addressController = TextEditingController(
                      text: controller.userAddress.value,
                    );
                    final phoneController = TextEditingController(
                      text: controller.userPhone.value,
                    );
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Edit Shipping Address"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                              TextField(
                                controller: addressController,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                ),
                              ),
                              TextField(
                                controller: phoneController,
                                decoration: InputDecoration(labelText: 'Phone'),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                controller.userName.value =
                                    nameController.text.trim();
                                controller.userAddress.value =
                                    addressController.text.trim();
                                controller.userPhone.value =
                                    phoneController.text.trim();
                                await controller.saveUserData();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              },
                              child: Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ImageIcon(
                    AssetImage(AppIcons.edit),
                    size: AppSize.height(height: 2.2),
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSize.height(height: 1.0)),
            child: Column(
              spacing: AppSize.height(height: 1.0),
              children: [
                Builder(
                  builder: (context) {
                    final controller = Get.find<CheckoutViewController>();
                    return Column(
                      children: [
                        Row(
                          spacing: AppSize.width(width: 1.5),
                          children: [
                            ImageIcon(
                              AssetImage(AppIcons.person),
                              size: AppSize.height(height: 2.0),
                            ),
                            Obx(
                              () => AppText(title: controller.userName.value),
                            ),
                          ],
                        ),
                        Row(
                          spacing: AppSize.width(width: 1.5),
                          children: [
                            ImageIcon(
                              AssetImage(AppIcons.phone),
                              size: AppSize.height(height: 2.0),
                            ),
                            Obx(
                              () => AppText(title: controller.userPhone.value),
                            ),
                          ],
                        ),
                        Row(
                          spacing: AppSize.width(width: 1.5),
                          children: [
                            ImageIcon(
                              AssetImage(AppIcons.marker),
                              size: AppSize.height(height: 2.0),
                            ),
                            Flexible(
                              child: Obx(
                                () => AppText(
                                  title: controller.userAddress.value,
                                  maxLine: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
