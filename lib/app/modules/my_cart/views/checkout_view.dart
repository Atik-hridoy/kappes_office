// ignore_for_file: unused_local_variable

import 'package:canuck_mall/app/localization/app_static_key.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/checkout_view_controller.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/my_cart_controller.dart';
import 'package:canuck_mall/app/modules/my_cart/widgets/promo_code_text_field.dart';
import 'package:canuck_mall/app/modules/my_cart/controllers/coupon_controller.dart';
import 'package:canuck_mall/app/modules/my_cart/widgets/shipping_address_card.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:canuck_mall/app/widgets/app_button/app_common_button.dart';
import 'package:canuck_mall/app/widgets/app_button/custom_dropdown_button.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/app_colors.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  double itemCost = 0.0;
  double shippingFee = 0.0;
  double discount = 0.0;
  double total = 0.0;
  bool _agreedToTnC = false;
  String? shopId;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null) {
      if (args['itemCost'] != null) {
        itemCost = (args['itemCost'] as num).toDouble();
      }
      if (args['shopId'] != null && (args['shopId'] as String).isNotEmpty) {
        shopId = args['shopId'] as String;
      }
      if (args['products'] != null) {
        products = args['products'] as List<dynamic>;
      }
    }
    _calculateTotal();
  }

  void _calculateTotal() {
    setState(() {
      total = itemCost + shippingFee - discount;
      if (total < 0) total = 0;
    });
  }

  // Coupon logic handled by CouponController and backend

  @override
  Widget build(BuildContext context) {
    return _buildCheckoutContent(context);
  }

  Widget _buildCheckoutContent(BuildContext context) {
    final controller = Get.find<CheckoutViewController>();
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
                  /// shipping address
                  const ShippingAddressCard(),

                  /// delivery options
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
                    type: 'deliveryOptions',
                    onChanged: (String? value) {},
                    items: ['Standard', 'Express', 'Overnight'],
                    value: 'Express',
                  ),

                  /// payment method
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
                    hintText: AppStaticKey.chooseDeliveryOption,
                    type: 'paymentMethod',
                    onChanged: (v) {},
                    items: ['Cod', 'Card', 'Online'],
                    value: 'Cod',
                  ),
                  SizedBox(height: AppSize.height(height: 2.0)),
                ],
              ),
            ),

            /// place order section
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSize.height(height: 2.5)),
                  topRight: Radius.circular(AppSize.height(height: 2.5)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSize.height(height: 2.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// coupon field
                    GetBuilder<CouponController>(
                      builder: (couponController) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PromoCodeTextField(
                              onApply: (code) async {
                                if (kDebugMode) {
                                  print('Applying coupon: $code');
                                }
                                final MyCartController cartController =
                                    Get.find<MyCartController>();
                                String? effectiveShopId = shopId;
                                if (effectiveShopId == null ||
                                    effectiveShopId.isEmpty) {
                                  if (cartController
                                              .cartData
                                              .value
                                              ?.data
                                              ?.items !=
                                          null &&
                                      cartController
                                          .cartData
                                          .value!
                                          .data!
                                          .items!
                                          .isNotEmpty) {
                                    // Assuming all items in cart are from the same shop, get the first product's shopId
                                    effectiveShopId =
                                        cartController
                                            .cartData
                                            .value!
                                            .data!
                                            .items!
                                            .first
                                            .productId
                                            ?.shopId ??
                                        '';
                                  }
                                }
                                if (kDebugMode) {
                                  print(
                                    'Coupon apply params: code=$code, shopId=$effectiveShopId, orderAmount=$itemCost',
                                  );
                                }
                                await couponController.applyCoupon(
                                  code,
                                  shopId: effectiveShopId ?? '',
                                  orderAmount: itemCost,
                                );
                                if (kDebugMode) {
                                  print(
                                    'Coupon response: ${couponController.couponResponse}',
                                  );
                                }
                                if (kDebugMode) {
                                  print(
                                    'Coupon error: ${couponController.errorMessage?.toString() ?? 'none'}',
                                  );
                                }
                                if (couponController.couponResponse != null) {
                                  setState(() {
                                    discount =
                                        couponController
                                            .couponResponse!
                                            .data
                                            .discountAmount;
                                    if (kDebugMode) {
                                      print(
                                        'Discount amount from backend: $discount',
                                      );
                                    }
                                    _calculateTotal();
                                  });
                                  if (couponController
                                      .couponResponse!
                                      .message
                                      .isNotEmpty) {
                                    Get.snackbar(
                                      'Coupon',
                                      couponController.couponResponse!.message,
                                    );
                                  }
                                } else if (couponController.errorMessage !=
                                    null) {
                                  setState(() {
                                    discount = 0.0;
                                    _calculateTotal();
                                  });
                                  Get.snackbar(
                                    'Coupon Error',
                                    couponController.errorMessage!,
                                  );
                                }
                              },
                            ),
                            if (couponController.isLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            if (couponController.couponResponse != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Coupon applied: '
                                        '${couponController.couponResponse!.data.coupon?.code}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Discount: -\$${couponController.couponResponse!.data.discountAmount.toStringAsFixed(2)}',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
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
                        AppText(
                          title: "\$${itemCost.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
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
                        AppText(
                          title: "\$${shippingFee.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
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
                        AppText(
                          title: "-\$${discount.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
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
                        AppText(
                          title: "\$${total.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(height: 1.5)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: AppSize.height(height: 2.0),
                          width: AppSize.height(height: 2.0),
                          child: Checkbox(
                            value: _agreedToTnC,
                            onChanged: (val) {
                              setState(() {
                                _agreedToTnC = val ?? false;
                              });
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
                        final controller = Get.find<CheckoutViewController>();
                        controller.handleCheckout(
                          context,
                          _agreedToTnC,
                          shopId,
                        );
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
