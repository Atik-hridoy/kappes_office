class OrderResponseModel {
  final bool success;
  final String message;
  final OrderData data;

  OrderResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
  return OrderResponseModel(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: OrderData.fromJson(json['data'] ?? {}),
  );
}
}

class OrderData {
  final Meta meta;
  final List<OrderResult> result;

  OrderData({required this.meta, required this.result});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      meta: Meta.fromJson(json['meta']),
      result: List<OrderResult>.from(
        json['result'].map((x) => OrderResult.fromJson(x)),
      ),
    );
  }
}

class Meta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Meta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
  return Meta(
    total: (json['total'] as num?)?.toInt() ?? 0,
    limit: (json['limit'] as num?)?.toInt() ?? 0,
    page: (json['page'] as num?)?.toInt() ?? 1,
    totalPage: (json['totalPage'] as num?)?.toInt() ?? 1,
  );
}
}

class OrderResult {
  final String id;
  final User user;
  final String shop;
  final List<OrderedProduct> products;
  final String deliveryOptions;
  final Coupon? coupon;
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
  final String createdAt;
  final String updatedAt;
  final String deliveryDate;

  OrderResult({
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
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) {
    return OrderResult(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user']),
      shop: json['shop'] ?? '',
      products: List<OrderedProduct>.from(
        json['products'].map((x) => OrderedProduct.fromJson(x)),
      ),
      deliveryOptions: json['deliveryOptions'] ?? '',
      coupon: json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null,
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
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      deliveryDate: json['deliveryDate'] ?? '',
    );
  }
}

class OrderedProduct {
  final Product product;

  final String variant;
  final int quantity;
  final double unitPrice;
  final String id;

  OrderedProduct({
    required this.product,
    required this.variant,
    required this.quantity,
    required this.unitPrice,
    required this.id,
  });

  factory OrderedProduct.fromJson(Map<String, dynamic> json) {
  return OrderedProduct(
    product: Product.fromJson(json['product'] ?? {}),
    variant: json['variant'] ?? '',
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    id: json['_id'] ?? '',
  );
}
}

class Product {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final int totalStock;
  final List<String> images;
  final bool isFeatured;
  final List<String> tags;
  final double avgRating;
  final int purchaseCount;
  final int viewCount;
  final String categoryId;
  final String subcategoryId;
  final String shopId;
  final String brandId;
  final String createdBy;
  final List<String> reviews;
  final int totalReviews;
  final List<ProductVariantDetail> productVariantDetails;
  final bool isDeleted;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final bool isRecommended;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.totalStock,
    required this.images,
    required this.isFeatured,
    required this.tags,
    required this.avgRating,
    required this.purchaseCount,
    required this.viewCount,
    required this.categoryId,
    required this.subcategoryId,
    required this.shopId,
    required this.brandId,
    required this.createdBy,
    required this.reviews,
    required this.totalReviews,
    required this.productVariantDetails,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isRecommended,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  final imagesJson = json['images'];
  final reviewsJson = json['reviews'];
  final variantsJson = json['product_variant_Details'];

  return Product(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
    totalStock: (json['totalStock'] as num?)?.toInt() ?? 0,
    images: imagesJson is List ? List<String>.from(imagesJson) : <String>[],
    isFeatured: json['isFeatured'] ?? false,
    tags: json['tags'] is List ? List<String>.from(json['tags']) : <String>[],
    avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
    purchaseCount: (json['purchaseCount'] as num?)?.toInt() ?? 0,
    viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
    categoryId: json['categoryId'] ?? '',
    subcategoryId: json['subcategoryId'] ?? '',
    shopId: json['shopId'] ?? '',
    brandId: json['brandId'] ?? '',
    createdBy: json['createdBy'] ?? '',
    reviews:
        reviewsJson is List ? List<String>.from(reviewsJson) : <String>[],
    totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
    productVariantDetails: variantsJson is List
        ? List<ProductVariantDetail>.from(
            variantsJson.map((x) => ProductVariantDetail.fromJson(x)),
          )
        : <ProductVariantDetail>[],
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'],
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
    isRecommended: json['isRecommended'] ?? false,
  );
}
}

class ProductVariantDetail {
  final String variantId;
  final int variantQuantity;
  final double variantPrice;

  ProductVariantDetail({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) {
    return ProductVariantDetail(
      variantId: json['variantId'],
      variantQuantity: json['variantQuantity'],
      variantPrice: (json['variantPrice'] as num).toDouble(),
    );
  }
}

class Coupon {
  final String id;
  final String code;
  final String shopId;
  final String createdBy;
  final String discountType;
  final double discountValue;
  final double minOrderAmount;
  final double maxDiscountAmount;
  final String startDate;
  final String endDate;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  Coupon({
    required this.id,
    required this.code,
    required this.shopId,
    required this.createdBy,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.maxDiscountAmount,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
  return Coupon(
    id: json['_id'] ?? '',
    code: json['code'] ?? '',
    shopId: json['shopId'] ?? '',
    createdBy: json['createdBy'] ?? '',
    discountType: json['discountType'] ?? '',
    discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
    minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 0.0,
    maxDiscountAmount: (json['maxDiscountAmount'] as num?)?.toDouble() ?? 0.0,
    startDate: json['startDate'] ?? '',
    endDate: json['endDate'] ?? '',
    isActive: json['isActive'] ?? false,
    isDeleted: json['isDeleted'] ?? false,
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );
}
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final bool verified;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] ?? '',
    fullName: json['full_name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
    verified: json['verified'] ?? false,
  );
}
}