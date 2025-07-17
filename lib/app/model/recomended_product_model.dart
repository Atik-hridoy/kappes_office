import 'dart:convert';

class ProductResponse {
  final bool success;
  final String message;
  final ProductData data;

  ProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    data: ProductData.fromJson(json['data'] ?? {}),
  );
}

class ProductData {
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
  final Category category;
  final Category subcategory;
  final Shop shop;
  final Brand brand;
  final String createdBy;
  final List<dynamic> reviews;
  final int totalReviews;
  final List<ProductVariantDetails> productVariantDetails;
  final bool isDeleted;
  final bool isRecommended;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductData({
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
    required this.category,
    required this.subcategory,
    required this.shop,
    required this.brand,
    required this.createdBy,
    required this.reviews,
    required this.totalReviews,
    required this.productVariantDetails,
    required this.isDeleted,
    required this.isRecommended,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
    totalStock: json['totalStock'] ?? 0,
    images: json['images'] != null ? List<String>.from(json['images']) : [],
    isFeatured: json['isFeatured'] ?? false,
    tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
    purchaseCount: json['purchaseCount'] != null && json['purchaseCount'] is num ? int.tryParse(json['purchaseCount'].toString()) ?? 0 : 0,
    viewCount: json['viewCount'] ?? 0,
    category: Category.fromJson(json['categoryId'] ?? {}),
    subcategory: Category.fromJson(json['subcategoryId'] ?? {}),
    shop: Shop.fromJson(json['shopId'] ?? {}),
    brand: Brand.fromJson(json['brandId'] ?? {}),
    createdBy: json['createdBy'] ?? '',
    reviews: json['reviews'] ?? [],
    totalReviews: json['totalReviews'] ?? 0,
    productVariantDetails: (json['product_variant_Details'] as List)
        .map((e) => ProductVariantDetails.fromJson(e))
        .toList(),
    isDeleted: json['isDeleted'] ?? false,
    isRecommended: json['isRecommended'] ?? false,
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
  );
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
  );
}

class Brand {
  final String id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
  );
}

class Shop {
  final String id;
  final String name;
  final String logo;
  final Address address;

  Shop({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    logo: json['logo'] ?? '',
    address: Address.fromJson(json['address'] ?? {}),
  );
}

class Address {
  final String province;
  final String city;
  final String territory;
  final String country;
  final String detailAddress;

  Address({
    required this.province,
    required this.city,
    required this.territory,
    required this.country,
    required this.detailAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    province: json['province'] ?? '',
    city: json['city'] ?? '',
    territory: json['territory'] ?? '',
    country: json['country'] ?? '',
    detailAddress: json['detail_address'] ?? '',
  );
}

class ProductVariantDetails {
  final Variant variantId;
  final int variantQuantity;
  final double variantPrice;

  ProductVariantDetails({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariantDetails.fromJson(Map<String, dynamic> json) =>
      ProductVariantDetails(
        variantId: Variant.fromJson(json['variantId'] ?? {}),
        variantQuantity: json['variantQuantity'] ?? 0,
        variantPrice: (json['variantPrice'] as num?)?.toDouble() ?? 0.0,
      );
}

class Variant {
  final String id;
  final String categoryId;
  final String subCategoryId;
  final String createdBy;
  final List<dynamic> networkType;
  final String size;
  final bool isDeleted;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ColorData color;

  Variant({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.createdBy,
    required this.networkType,
    required this.size,
    required this.isDeleted,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.color,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json['_id'] ?? '',
    categoryId: json['categoryId'] ?? '',
    subCategoryId: json['subCategoryId'] ?? '',
    createdBy: json['createdBy'] ?? '',
    networkType: json['network_type'] ?? [],
    size: json['size'] ?? '',
    isDeleted: json['isDeleted'] ?? false,
    slug: json['slug'] ?? '',
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    color: ColorData.fromJson(json['color'] ?? {}),
  );
}

class ColorData {
  final String name;
  final String code;

  ColorData({
    required this.name,
    required this.code,
  });

  factory ColorData.fromJson(Map<String, dynamic> json) => ColorData(
    name: json['name'] ?? '',
    code: json['code'] ?? '',
  );
}
