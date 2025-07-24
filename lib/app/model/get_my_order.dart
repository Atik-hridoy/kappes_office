import 'dart:convert';

// --- Top Level Model ---
class GetMyOrder {
  final bool success;
  final String message;
  final Data data;
  final List<String>? errorMessages; // Assuming this could be null or empty
  final int? statusCode; // Assuming this is an optional field

  const GetMyOrder({
    required this.success,
    required this.message,
    required this.data,
    this.errorMessages,
    this.statusCode,
  });

  factory GetMyOrder.fromJson(Map<String, dynamic> json) {
    return GetMyOrder(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
      errorMessages:
          (json['errorMessages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'errorMessages': errorMessages,
      'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'GetMyOrder(success: $success, message: $message, data: $data, errorMessages: $errorMessages, statusCode: $statusCode)';
  }
}

// --- Data Model ---
class Data {
  final Meta meta;
  final List<Order> result;

  const Data({required this.meta, required this.result});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
      result:
          (json['result'] as List<dynamic>)
              .map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'result': result.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Data(meta: $meta, result: $result)';
  }
}

// --- Meta Model ---
class Meta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  const Meta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] as int,
      limit: json['limit'] as int,
      page: json['page'] as int,
      totalPage: json['totalPage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }

  @override
  String toString() {
    return 'Meta(total: $total, limit: $limit, page: $page, totalPage: $totalPage)';
  }
}

// --- Order Model ---
class Order {
  final String id; // Renamed _id to id for Dart conventions
  final User user;
  final String shopId; // Renamed shop to shopId for clarity
  final List<ProductDetail> products;
  final String deliveryOptions;
  final Coupon? coupon; // Coupon can be null
  final int discount;
  final int deliveryCharge;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentId; // Renamed payment to paymentId for clarity
  final bool isPaymentTransferdToVendor;
  final bool isNeedRefund;
  final double totalAmount;
  final double finalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deliveryDate;

  const Order({
    required this.id,
    required this.user,
    required this.shopId,
    required this.products,
    required this.deliveryOptions,
    this.coupon,
    required this.discount,
    required this.deliveryCharge,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentId,
    required this.isPaymentTransferdToVendor,
    required this.isNeedRefund,
    required this.totalAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      shopId: json['shop'] as String,
      products:
          (json['products'] as List<dynamic>)
              .map((e) => ProductDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
      deliveryOptions: json['deliveryOptions'] as String,
      coupon:
          json['coupon'] != null
              ? Coupon.fromJson(json['coupon'] as Map<String, dynamic>)
              : null,
      discount: json['discount'] as int,
      deliveryCharge: json['deliveryCharge'] as int,
      status: json['status'] as String,
      shippingAddress: json['shippingAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentId: json['payment'] as String,
      isPaymentTransferdToVendor: json['isPaymentTransferdToVendor'] as bool,
      isNeedRefund: json['isNeedRefund'] as bool,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'shop': shopId,
      'products': products.map((e) => e.toJson()).toList(),
      'deliveryOptions': deliveryOptions,
      'coupon': coupon?.toJson(), // handle null coupon
      'discount': discount,
      'deliveryCharge': deliveryCharge,
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'payment': paymentId,
      'isPaymentTransferdToVendor': isPaymentTransferdToVendor,
      'isNeedRefund': isNeedRefund,
      'totalAmount': totalAmount,
      'finalAmount': finalAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Order(id: $id, user: $user, shopId: $shopId, products: $products, deliveryOptions: $deliveryOptions, coupon: $coupon, discount: $discount, deliveryCharge: $deliveryCharge, status: $status, shippingAddress: $shippingAddress, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, paymentId: $paymentId, isPaymentTransferdToVendor: $isPaymentTransferdToVendor, isNeedRefund: $isNeedRefund, totalAmount: $totalAmount, finalAmount: $finalAmount, createdAt: $createdAt, updatedAt: $updatedAt, deliveryDate: $deliveryDate)';
  }
}

// --- User Model ---
class User {
  final String id; // Renamed _id to id
  final String googleId;
  final String facebookId;
  final String provider;
  final String fullName; // Renamed full_name to fullName
  final String role;
  final String email;
  final String image;
  final String phone;
  final List<dynamic>
  businessInformations; // Define a more specific model if needed
  final String status;
  final bool verified;
  final bool isDeleted;
  final String stripeCustomerId;
  final String stripeConnectedAccount;
  final int tokenVersion;
  final int loginCount;
  final int balance;
  final DateTime joinDate;
  final List<dynamic>
  recentSearchLocations; // Define a more specific model if needed
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v; // Renamed __v to v
  final DateTime lastLogin;
  final String address;

  const User({
    required this.id,
    required this.googleId,
    required this.facebookId,
    required this.provider,
    required this.fullName,
    required this.role,
    required this.email,
    required this.image,
    required this.phone,
    required this.businessInformations,
    required this.status,
    required this.verified,
    required this.isDeleted,
    required this.stripeCustomerId,
    required this.stripeConnectedAccount,
    required this.tokenVersion,
    required this.loginCount,
    required this.balance,
    required this.joinDate,
    required this.recentSearchLocations,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lastLogin,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      googleId: json['googleId'] as String,
      facebookId: json['facebookId'] as String,
      provider: json['provider'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      phone: json['phone'] as String,
      businessInformations: json['business_informations'] as List<dynamic>,
      status: json['status'] as String,
      verified: json['verified'] as bool,
      isDeleted: json['isDeleted'] as bool,
      stripeCustomerId: json['stripeCustomerId'] as String,
      stripeConnectedAccount: json['stripeConnectedAccount'] as String,
      tokenVersion: json['tokenVersion'] as int,
      loginCount: json['loginCount'] as int,
      balance: json['balance'] as int,
      joinDate: DateTime.parse(json['joinDate'] as String),
      recentSearchLocations: json['recentSearchLocations'] as List<dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'googleId': googleId,
      'facebookId': facebookId,
      'provider': provider,
      'full_name': fullName,
      'role': role,
      'email': email,
      'image': image,
      'phone': phone,
      'business_informations': businessInformations,
      'status': status,
      'verified': verified,
      'isDeleted': isDeleted,
      'stripeCustomerId': stripeCustomerId,
      'stripeConnectedAccount': stripeConnectedAccount,
      'tokenVersion': tokenVersion,
      'loginCount': loginCount,
      'balance': balance,
      'joinDate': joinDate.toIso8601String(),
      'recentSearchLocations': recentSearchLocations,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'lastLogin': lastLogin.toIso8601String(),
      'address': address,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, phone: $phone, status: $status)';
  }
}

// --- ProductDetail Model (for products array within Order) ---
class ProductDetail {
  final Product product;
  final String variant;
  final int quantity;
  final double unitPrice;
  final String id; // Renamed _id to id

  const ProductDetail({
    required this.product,
    required this.variant,
    required this.quantity,
    required this.unitPrice,
    required this.id,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      variant: json['variant'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'variant': variant,
      'quantity': quantity,
      'unitPrice': unitPrice,
      '_id': id,
    };
  }

  @override
  String toString() {
    return 'ProductDetail(product: ${product.name}, quantity: $quantity, unitPrice: $unitPrice)';
  }
}

// --- Product Model (nested within ProductDetail) ---
class Product {
  final String id; // Renamed _id to id
  final String name;
  final String description;
  final double basePrice;
  final int totalStock;
  final List<String> images;
  final bool isFeatured;
  final List<String> tags;
  final int avgRating;
  final int purchaseCount;
  final int viewCount;
  final String categoryId;
  final String subcategoryId;
  final String shopId;
  final String brandId;
  final String createdBy;
  final List<String> reviews;
  final int totalReviews;
  final List<ProductVariantDetail>
  productVariantDetails; // Renamed product_variant_Details
  final bool isDeleted;
  final dynamic deletedAt; // Can be null
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v; // Renamed __v to v
  final bool isRecommended;

  const Product({
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
    required this.v,
    required this.isRecommended,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      totalStock: json['totalStock'] as int,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      isFeatured: json['isFeatured'] as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      avgRating: json['avg_rating'] as int,
      purchaseCount: json['purchaseCount'] as int,
      viewCount: json['viewCount'] as int,
      categoryId: json['categoryId'] as String,
      subcategoryId: json['subcategoryId'] as String,
      shopId: json['shopId'] as String,
      brandId: json['brandId'] as String,
      createdBy: json['createdBy'] as String,
      reviews:
          (json['reviews'] as List<dynamic>).map((e) => e as String).toList(),
      totalReviews: json['totalReviews'] as int,
      productVariantDetails:
          (json['product_variant_Details'] as List<dynamic>)
              .map(
                (e) => ProductVariantDetail.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      isDeleted: json['isDeleted'] as bool,
      deletedAt: json['deletedAt'], // Can be null
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
      isRecommended: json['isRecommended'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'totalStock': totalStock,
      'images': images,
      'isFeatured': isFeatured,
      'tags': tags,
      'avg_rating': avgRating,
      'purchaseCount': purchaseCount,
      'viewCount': viewCount,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'shopId': shopId,
      'brandId': brandId,
      'createdBy': createdBy,
      'reviews': reviews,
      'totalReviews': totalReviews,
      'product_variant_Details':
          productVariantDetails.map((e) => e.toJson()).toList(),
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'isRecommended': isRecommended,
    };
  }
}

// --- ProductVariantDetail Model ---
class ProductVariantDetail {
  final String variantId;
  final int variantQuantity;
  final int variantPrice;

  const ProductVariantDetail({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) {
    return ProductVariantDetail(
      variantId: json['variantId'] as String,
      variantQuantity: json['variantQuantity'] as int,
      variantPrice: json['variantPrice'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'variantQuantity': variantQuantity,
      'variantPrice': variantPrice,
    };
  }

  @override
  String toString() {
    return 'ProductVariantDetail(variantId: $variantId, variantQuantity: $variantQuantity, variantPrice: $variantPrice)';
  }
}

// --- Coupon Model ---
class Coupon {
  final String id; // Renamed _id to id
  final String code;
  final String shopId;
  final String createdBy;
  final String discountType;
  final double discountValue;
  final int minOrderAmount;
  final int maxDiscountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v; // Renamed __v to v

  const Coupon({
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
    required this.v,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['_id'] as String,
      code: json['code'] as String,
      shopId: json['shopId'] as String,
      createdBy: json['createdBy'] as String,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      minOrderAmount: json['minOrderAmount'] as int,
      maxDiscountAmount: json['maxDiscountAmount'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'shopId': shopId,
      'createdBy': createdBy,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'Coupon(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue)';
  }
}
