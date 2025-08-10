// Model for Order Creation Request
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

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        shop: json['shop'] ?? '',
        products: (json['products'] as List<dynamic>?)?.map((e) => OrderProduct.fromJson(e as Map<String, dynamic>)).toList() ?? [],
        coupon: json['coupon'],
        shippingAddress: json['shippingAddress'] ?? '',
        paymentMethod: json['paymentMethod'] ?? '',
        deliveryOptions: json['deliveryOptions'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'shop': shop,
        'products': products.map((e) => e.toJson()).toList(),
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
  final double totalPrice;

  OrderProduct({
    required this.product,
    required this.variant,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        product: json['product'] ?? '',
        variant: json['variant'] ?? '',
        quantity: json['quantity'] ?? 0,
        totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'product': product,
        'variant': variant,
        'quantity': quantity,
        'totalPrice': totalPrice,
      };
}

// Model for Order Creation Response
class OrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  OrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class OrderData {
  final String id;
  final String user;
  final String shop;
  final List<OrderItem> products;
  final String deliveryOptions;
  final String? coupon;
  final double discount;
  final double deliveryCharge;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String payment;
  final bool isPaymentTransferdToVendor;
  final bool isNeedRefund;
  final double totalAmount;
  final double finalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deliveryDate;
  final int v;

  OrderData({
    required this.id,
    required this.user,
    required this.shop,
    required this.products,
    required this.deliveryOptions,
    this.coupon,
    required this.discount,
    required this.deliveryCharge,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.payment,
    required this.isPaymentTransferdToVendor,
    required this.isNeedRefund,
    required this.totalAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryDate,
    required this.v,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json['_id'] ?? '',
        user: json['user'] ?? '',
        shop: json['shop'] ?? '',
        products: (json['products'] as List<dynamic>?)?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList() ?? [],
        deliveryOptions: json['deliveryOptions'] ?? '',
        coupon: json['coupon'],
        discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
        deliveryCharge: (json['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
        status: json['status'] ?? '',
        shippingAddress: json['shippingAddress'] ?? '',
        paymentMethod: json['paymentMethod'] ?? '',
        paymentStatus: json['paymentStatus'] ?? '',
        payment: json['payment'] ?? '',
        isPaymentTransferdToVendor: json['isPaymentTransferdToVendor'] ?? false,
        isNeedRefund: json['isNeedRefund'] ?? false,
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
        deliveryDate: DateTime.tryParse(json['deliveryDate'] ?? '') ?? DateTime.now(),
        v: json['__v'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user': user,
        'shop': shop,
        'products': products.map((e) => e.toJson()).toList(),
        'deliveryOptions': deliveryOptions,
        'coupon': coupon,
        'discount': discount,
        'deliveryCharge': deliveryCharge,
        'status': status,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'payment': payment,
        'isPaymentTransferdToVendor': isPaymentTransferdToVendor,
        'isNeedRefund': isNeedRefund,
        'totalAmount': totalAmount,
        'finalAmount': finalAmount,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'deliveryDate': deliveryDate.toIso8601String(),
        '__v': v,
      };
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

  Map<String, dynamic> toJson() => {
        '_id': id,
        'product': product,
        'variant': variant,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };
}