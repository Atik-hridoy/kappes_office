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

  OrderData({
    required this.id,
    required this.user,
    required this.shop,
    required this.products,
    required this.deliveryOptions,
    required this.deliveryCharge,
    required this.finalAmount,
    required this.deliveryDate,
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
