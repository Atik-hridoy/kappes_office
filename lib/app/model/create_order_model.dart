class OrderRequest {
  final String shop;
  final List<OrderProduct> products;
  final String? coupon;
  final String shippingAddress;
  final String paymentMethod;
  final String deliveryOptions;

  OrderRequest({
    required this.shop,
    required this.products,
    this.coupon,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.deliveryOptions,
  });

  Map<String, dynamic> toJson() => {
    'shop': shop,
    'products': products.map((p) => p.toJson()).toList(),
    if (coupon != null) 'coupon': coupon,
    'shippingAddress': shippingAddress,
    'paymentMethod': paymentMethod,
    'deliveryOptions': deliveryOptions,
  };
}

class OrderProduct {
  final String product;
  final String variant;
  final int quantity;

  /// Create OrderProduct from CartItem (for checkout)
  factory OrderProduct.fromCartItem(dynamic cartItem) {
    // Accepts CartItem from get_cart_model.dart
    // Defensive: cartItem.productId and cartItem.variantId may be null, so fallback to ''
    return OrderProduct(
      product: cartItem.productId?.id ?? '',
      variant: cartItem.variantId?.id ?? '',
      quantity: cartItem.variantQuantity ?? 1,
    );
  }

  OrderProduct({
    required this.product,
    required this.variant,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'product': product,
    'variant': variant,
    'quantity': quantity,
  };
}

class OrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  OrderResponse({required this.success, required this.message, this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
  );
}

class OrderData {
  final String id;
  final String user;
  final String shop;
  final List<OrderItem> products;
  final String deliveryOptions;
  final double deliveryCharge;
  final double finalAmount;
  final DateTime deliveryDate;
  final String? coupon;
  final double discount;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentId;
  final bool isPaymentTransferdToVendor;
  final bool isNeedRefund;
  final double totalAmount;

  OrderData({
    required this.id,
    required this.user,
    required this.shop,
    required this.products,
    required this.deliveryOptions,
    required this.deliveryCharge,
    required this.finalAmount,
    required this.deliveryDate,
    this.coupon,
    required this.discount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentId,
    required this.isPaymentTransferdToVendor,
    required this.isNeedRefund,
    required this.totalAmount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json['_id'] ?? '',
    user: json['user'] ?? '',
    shop: json['shop'] ?? '',
    products:
        (json['products'] as List).map((p) => OrderItem.fromJson(p)).toList(),
    deliveryOptions: json['deliveryOptions'] ?? '',
    deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
    finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
    deliveryDate: DateTime.parse(
      json['deliveryDate'] ?? DateTime.now().toString(),
    ),
    coupon: json['coupon'], // Optional
    discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    status: json['status'] ?? 'Pending',
    shippingAddress: json['shippingAddress'] ?? '',
    paymentMethod: json['paymentMethod'] ?? '',
    paymentStatus: json['paymentStatus'] ?? 'Unpaid',
    paymentId: json['payment'] ?? '',
    isPaymentTransferdToVendor: json['isPaymentTransferdToVendor'] ?? false,
    isNeedRefund: json['isNeedRefund'] ?? false,
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
  );
}

class OrderItem {
  final String id;
  final String product;
  final String variant;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.id,
    required this.product,
    required this.variant,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['_id'] ?? '',
    product: json['product'] ?? '',
    variant: json['variant'] ?? '',
    quantity: json['quantity'] ?? 0,
    unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
  );
}
