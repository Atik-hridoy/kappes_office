class GetMyOrder {
  final bool success;
  final String message;
  final OrderData data;

  GetMyOrder({
    required this.success,
    required this.message,
    required this.data,
    required errorMessages,
    required statusCode,
  });

  factory GetMyOrder.fromJson(Map<String, dynamic> json) => GetMyOrder(
    success: json["success"],
    message: json["message"],
    data: OrderData.fromJson(json["data"]),
    errorMessages: null,
    statusCode: null,
  );

  get errorMessages => null;

  get statusCode => null;

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class OrderData {
  final Meta meta;
  final List<Order> result;

  OrderData({required this.meta, required this.result});

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    meta: Meta.fromJson(json["meta"]),
    result: List<Order>.from(json["result"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta.toJson(),
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
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

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    limit: json["limit"],
    page: json["page"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "limit": limit,
    "page": page,
    "totalPage": totalPage,
  };
}

class Order {
  final String id;
  final User user;
  final String shop;
  final List<OrderProduct> products;
  final String deliveryOptions;
  final Coupon coupon;
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

  Order({
    required this.id,
    required this.user,
    required this.shop,
    required this.products,
    required this.deliveryOptions,
    required this.coupon,
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

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"],
    user: User.fromJson(json["user"]),
    shop: json["shop"],
    products: List<OrderProduct>.from(
      json["products"].map((x) => OrderProduct.fromJson(x)),
    ),
    deliveryOptions: json["deliveryOptions"],
    coupon: Coupon.fromJson(json["coupon"]),
    discount: json["discount"]?.toDouble() ?? 0.0,
    deliveryCharge: json["deliveryCharge"]?.toDouble() ?? 0.0,
    status: json["status"],
    shippingAddress: json["shippingAddress"],
    paymentMethod: json["paymentMethod"],
    paymentStatus: json["paymentStatus"],
    payment: json["payment"],
    isPaymentTransferdToVendor: json["isPaymentTransferdToVendor"],
    isNeedRefund: json["isNeedRefund"],
    totalAmount: json["totalAmount"]?.toDouble() ?? 0.0,
    finalAmount: json["finalAmount"]?.toDouble() ?? 0.0,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deliveryDate: DateTime.parse(json["deliveryDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user.toJson(),
    "shop": shop,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "deliveryOptions": deliveryOptions,
    "coupon": coupon.toJson(),
    "discount": discount,
    "deliveryCharge": deliveryCharge,
    "status": status,
    "shippingAddress": shippingAddress,
    "paymentMethod": paymentMethod,
    "paymentStatus": paymentStatus,
    "payment": payment,
    "isPaymentTransferdToVendor": isPaymentTransferdToVendor,
    "isNeedRefund": isNeedRefund,
    "totalAmount": totalAmount,
    "finalAmount": finalAmount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "deliveryDate": deliveryDate.toIso8601String(),
  };
}

class User {
  final String id;
  final String googleId;
  final String facebookId;
  final String provider;
  final String fullName;
  final String role;
  final String email;
  final String image;
  final String phone;
  final List<dynamic> businessInformations;
  final String status;
  final bool verified;
  final bool isDeleted;
  final String stripeCustomerId;
  final String stripeConnectedAccount;
  final int tokenVersion;
  final int loginCount;
  final int balance;
  final DateTime joinDate;
  final List<dynamic> recentSearchLocations;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final DateTime lastLogin;
  final String address;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    googleId: json["googleId"],
    facebookId: json["facebookId"],
    provider: json["provider"],
    fullName: json["full_name"],
    role: json["role"],
    email: json["email"],
    image: json["image"],
    phone: json["phone"],
    businessInformations: List<dynamic>.from(
      json["business_informations"].map((x) => x),
    ),
    status: json["status"],
    verified: json["verified"],
    isDeleted: json["isDeleted"],
    stripeCustomerId: json["stripeCustomerId"],
    stripeConnectedAccount: json["stripeConnectedAccount"],
    tokenVersion: json["tokenVersion"],
    loginCount: json["loginCount"],
    balance: json["balance"],
    joinDate: DateTime.parse(json["joinDate"]),
    recentSearchLocations: List<dynamic>.from(
      json["recentSearchLocations"].map((x) => x),
    ),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lastLogin: DateTime.parse(json["lastLogin"]),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "googleId": googleId,
    "facebookId": facebookId,
    "provider": provider,
    "full_name": fullName,
    "role": role,
    "email": email,
    "image": image,
    "phone": phone,
    "business_informations": List<dynamic>.from(
      businessInformations.map((x) => x),
    ),
    "status": status,
    "verified": verified,
    "isDeleted": isDeleted,
    "stripeCustomerId": stripeCustomerId,
    "stripeConnectedAccount": stripeConnectedAccount,
    "tokenVersion": tokenVersion,
    "loginCount": loginCount,
    "balance": balance,
    "joinDate": joinDate.toIso8601String(),
    "recentSearchLocations": List<dynamic>.from(
      recentSearchLocations.map((x) => x),
    ),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "lastLogin": lastLogin.toIso8601String(),
    "address": address,
  };
}

class OrderProduct {
  final Product product;
  final String variant;
  final int quantity;
  final double unitPrice;
  final String id;

  OrderProduct({
    required this.product,
    required this.variant,
    required this.quantity,
    required this.unitPrice,
    required this.id,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
    product: Product.fromJson(json["product"]),
    variant: json["variant"],
    quantity: json["quantity"],
    unitPrice: json["unitPrice"]?.toDouble() ?? 0.0,
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "variant": variant,
    "quantity": quantity,
    "unitPrice": unitPrice,
    "_id": id,
  };
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
  final List<ProductVariantDetail> productVariantDetails;
  final bool isDeleted;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final bool isRecommended;
  final String productId;

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
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.isRecommended,
    required this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    basePrice: json["basePrice"]?.toDouble() ?? 0.0,
    totalStock: json["totalStock"],
    images: List<String>.from(json["images"].map((x) => x)),
    isFeatured: json["isFeatured"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    avgRating: json["avg_rating"],
    purchaseCount: json["purchaseCount"],
    viewCount: json["viewCount"],
    categoryId: json["categoryId"],
    subcategoryId: json["subcategoryId"],
    shopId: json["shopId"],
    brandId: json["brandId"],
    createdBy: json["createdBy"],
    reviews: List<String>.from(json["reviews"].map((x) => x)),
    totalReviews: json["totalReviews"],
    productVariantDetails: List<ProductVariantDetail>.from(
      json["product_variant_Details"].map(
        (x) => ProductVariantDetail.fromJson(x),
      ),
    ),
    isDeleted: json["isDeleted"],
    deletedAt: json["deletedAt"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isRecommended: json["isRecommended"] ?? false,
    productId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "basePrice": basePrice,
    "totalStock": totalStock,
    "images": List<dynamic>.from(images.map((x) => x)),
    "isFeatured": isFeatured,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "avg_rating": avgRating,
    "purchaseCount": purchaseCount,
    "viewCount": viewCount,
    "categoryId": categoryId,
    "subcategoryId": subcategoryId,
    "shopId": shopId,
    "brandId": brandId,
    "createdBy": createdBy,
    "reviews": List<dynamic>.from(reviews.map((x) => x)),
    "totalReviews": totalReviews,
    "product_variant_Details": List<dynamic>.from(
      productVariantDetails.map((x) => x.toJson()),
    ),
    "isDeleted": isDeleted,
    "deletedAt": deletedAt,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "isRecommended": isRecommended,
    "id": productId,
  };
}

class ProductVariantDetail {
  final String variantId;
  final int variantQuantity;
  final int variantPrice;

  ProductVariantDetail({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) =>
      ProductVariantDetail(
        variantId: json["variantId"],
        variantQuantity: json["variantQuantity"],
        variantPrice: json["variantPrice"],
      );

  Map<String, dynamic> toJson() => {
    "variantId": variantId,
    "variantQuantity": variantQuantity,
    "variantPrice": variantPrice,
  };
}

class Coupon {
  final String id;
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
  final int v;

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
    required this.v,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["_id"],
    code: json["code"],
    shopId: json["shopId"],
    createdBy: json["createdBy"],
    discountType: json["discountType"],
    discountValue: json["discountValue"]?.toDouble() ?? 0.0,
    minOrderAmount: json["minOrderAmount"],
    maxDiscountAmount: json["maxDiscountAmount"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    isActive: json["isActive"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "code": code,
    "shopId": shopId,
    "createdBy": createdBy,
    "discountType": discountType,
    "discountValue": discountValue,
    "minOrderAmount": minOrderAmount,
    "maxDiscountAmount": maxDiscountAmount,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
