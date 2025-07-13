import 'dart:convert';

// Main Product Model
class TrendingProductModel {
  final bool success;
  final String message;
  final ProductData data;

  TrendingProductModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TrendingProductModel.fromJson(Map<String, dynamic> json) {
    return TrendingProductModel(
      success: json['success'],
      message: json['message'],
      data: ProductData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Product Data Model
class ProductData {
  final ProductMeta meta;
  final List<Product> result;

  ProductData({
    required this.meta,
    required this.result,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      meta: ProductMeta.fromJson(json['meta']),
      result: List<Product>.from(json['result'].map((item) => Product.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'result': result.map((item) => item.toJson()).toList(),
    };
  }
}

// Meta Model for pagination information
class ProductMeta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  ProductMeta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
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
}

// Product Model
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
  final Category categoryId;
  final Category subcategoryId;
  final Shop shopId;
  final Brand brandId;
  final String createdBy;
  final List<String> reviews;
  final int totalReviews;
  final List<ProductVariant> productVariantDetails;
  final bool isDeleted;
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
    required this.createdAt,
    required this.updatedAt,
    required this.isRecommended,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      basePrice: json['basePrice'],
      totalStock: json['totalStock'],
      images: List<String>.from(json['images']),
      isFeatured: json['isFeatured'],
      tags: List<String>.from(json['tags']),
      avgRating: json['avg_rating'],
      purchaseCount: json['purchaseCount'],
      viewCount: json['viewCount'],
      categoryId: Category.fromJson(json['categoryId']),
      subcategoryId: Category.fromJson(json['subcategoryId']),
      shopId: Shop.fromJson(json['shopId']),
      brandId: Brand.fromJson(json['brandId']),
      createdBy: json['createdBy'],
      reviews: List<String>.from(json['reviews']),
      totalReviews: json['totalReviews'],
      productVariantDetails: List<ProductVariant>.from(json['product_variant_Details'].map((item) => ProductVariant.fromJson(item))),
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isRecommended: json['isRecommended'],
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
      'categoryId': categoryId.toJson(),
      'subcategoryId': subcategoryId.toJson(),
      'shopId': shopId.toJson(),
      'brandId': brandId.toJson(),
      'createdBy': createdBy,
      'reviews': reviews,
      'totalReviews': totalReviews,
      'product_variant_Details': productVariantDetails.map((item) => item.toJson()).toList(),
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isRecommended': isRecommended,
    };
  }
}

// Category Model
class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

// Shop Model
class Shop {
  final String id;
  final String name;

  Shop({
    required this.id,
    required this.name,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

// Brand Model
class Brand {
  final String id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

// ProductVariant Model
class ProductVariant {
  final String id;
  final String slug;
  final int variantQuantity;
  final double variantPrice;

  ProductVariant({
    required this.id,
    required this.slug,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['_id'],
      slug: json['slug'],
      variantQuantity: json['variantQuantity'],
      variantPrice: json['variantPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'slug': slug,
      'variantQuantity': variantQuantity,
      'variantPrice': variantPrice,
    };
  }
}
