import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/checkout_view_controller.dart';
import 'package:canuck_mall/app/modules/my_cart/widgets/promo_code_text_field.dart';
import 'package:canuck_mall/app/modules/my_cart/widgets/shipping_address_card.dart';

import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_button/custom_dropdown_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';

class CheckoutView extends GetView<CheckoutViewController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        title: AppText(
          title: AppStaticKey.checkout,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.height(height: 2.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Shipping Address
                  ShippingAddressCard(),

                  /// Delivery Options
                  SizedBox(height: AppSize.height(height: 2.0)),
                  AppText(
                    title: AppStaticKey.deliveryOptions,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  CustomDropdownButton(
                    hintText: AppStaticKey.chooseDeliveryOption,
                    type: "deliveryOptions",
                    onChanged:
                        controller.updateDeliveryOption, // Pass method here
                    items: [
                      "Express",
                      "Standard",
                      "Next-Day",
                    ], // Example options
                  ),

                  /// Payment Method
                  SizedBox(height: AppSize.height(height: 2.0)),
                  AppText(
                    title: AppStaticKey.paymentMethod,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: AppSize.height(height: 1.0)),
                  CustomDropdownButton(
                    hintText: AppStaticKey.choosePaymentMethod,
                    type: "paymentMethod",
                    onChanged:
                        controller.updatePaymentMethod, // Pass method here
                    items: ["Cod", "Credit Card", "PayPal"], // Example options
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),
                ],
              ),
            ),

            /// Place Order Section
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSize.height(height: 2.5)),
                  topRight: Radius.circular(AppSize.height(height: 2.5)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PromoCodeTextField(
                      onChanged: (value) {
                        controller.updateCoupon(value);
                      },
                    ),
                    SizedBox(height: AppSize.height(height: 2.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          title: AppStaticKey.itemCost,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => AppText(
                            title: "\$${controller.itemCost.value}",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          title: AppStaticKey.shippingFee,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => AppText(
                            title: "\$${controller.shippingFee.value}",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          title: AppStaticKey.discount,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => AppText(
                            title: "-\$${controller.discount.value}",
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: AppColors.lightGray),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          title: AppStaticKey.totalPrice,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Obx(
                          () => AppText(
                            title: "\$${controller.finalAmount.value}",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.5)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => SizedBox(
                            height: AppSize.height(height: 2.0),
                            width: AppSize.height(height: 2.0),
                            child: Checkbox(
                              value: controller.isRemember.value,
                              onChanged: (value) {
                                controller.isRemember.value =
                                    !controller.isRemember.value;
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              side: const BorderSide(
                                width: 1.0,
                                color: AppColors.lightGray,
                              ),
                              activeColor: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.width(width: 2.0)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: AppStaticKey.iHaveReadAndAgreeToTheWebsite,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(letterSpacing: 0),
                              children: [
                                TextSpan(
                                  text: AppStaticKey.termsAndConditions,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 2.0)),
                    AppCommonButton(
                      onPressed: () {
                        // When clicked, try to create an order
                        controller.createOrder();
                      },
                      title: AppStaticKey.placeOrder,
                      fontSize: AppSize.height(height: 2.0),
                    ),
                    SizedBox(height: AppSize.height(height: 3.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
