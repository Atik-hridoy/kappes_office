import 'dart:convert';

// A single response model for POST, GET, and DELETE actions
class WishlistResponse {
  final bool success;
  final String message;
  final WishlistData data;

  WishlistResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor for POST, GET, and DELETE responses
  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: WishlistData.fromJson(json['data'] ?? {}),
      );

  // Converts the object into JSON format
  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class WishlistData {
  final String user;
  final List<WishlistItem> items;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  WishlistData({
    required this.user,
    required this.items,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for POST, GET, and DELETE
  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
    user: json['user'] ?? '',
    items:
        (json['items'] as List<dynamic>?)
            ?.map((item) => WishlistItem.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [],
    id: json['_id'] ?? '',
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  // Converts the object into JSON format
  Map<String, dynamic> toJson() => {
    'user': user,
    'items': items.map((item) => item.toJson()).toList(),
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class WishlistItem {
  final Product product;
  final String id;
  final DateTime addedAt;

  WishlistItem({
    required this.product,
    required this.id,
    required this.addedAt,
  });

  // Factory constructor for POST, GET, and DELETE
  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    product: Product.fromJson(json['product'] ?? {}),
    id: json['_id'] ?? '',
    addedAt: DateTime.parse(
      json['addedAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  get imageUrl => null;

  get name => null;

  get price => null;

  // Converts the object into JSON format
  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    '_id': id,
    'addedAt': addedAt.toIso8601String(),
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
  final List<ProductVariant> productVariantDetails;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
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

  // Factory constructor for POST, GET, and DELETE responses
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
    totalStock: json['totalStock'] ?? 0,
    images: List<String>.from(json['images'] ?? []),
    isFeatured: json['isFeatured'] ?? false,
    tags: List<String>.from(json['tags'] ?? []),
    avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
    purchaseCount: json['purchaseCount'] ?? 0,
    viewCount: json['viewCount'] ?? 0,
    categoryId: json['categoryId'] ?? '',
    subcategoryId: json['subcategoryId'] ?? '',
    shopId: json['shopId'] ?? '',
    brandId: json['brandId'] ?? '',
    createdBy: json['createdBy'] ?? '',
    reviews: List<String>.from(json['reviews'] ?? []),
    totalReviews: json['totalReviews'] ?? 0,
    productVariantDetails:
        (json['product_variant_Details'] as List<dynamic>?)
            ?.map(
              (variant) =>
                  ProductVariant.fromJson(variant as Map<String, dynamic>),
            )
            .toList() ??
        [],
    isDeleted: json['isDeleted'] ?? false,
    deletedAt:
        json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] ?? DateTime.now().toIso8601String(),
    ),
    isRecommended: json['isRecommended'] ?? false,
  );

  Map<String, dynamic> toJson() => {
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
        productVariantDetails.map((x) => x.toJson()).toList(),
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isRecommended': isRecommended,
  };
}

class ProductVariant {
  final String variantId;
  final int variantQuantity;
  final double variantPrice;

  ProductVariant({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    variantId: json['variantId'] ?? '',
    variantQuantity: json['variantQuantity'] ?? 0,
    variantPrice: (json['variantPrice'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'variantId': variantId,
    'variantQuantity': variantQuantity,
    'variantPrice': variantPrice,
  };
}
