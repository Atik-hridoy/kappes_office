class SearchProduct {
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
  final Subcategory subcategoryId;
  final Shop shopId;
  final Brand brandId;
  final String createdBy;
  final List<dynamic> reviews;
  final int totalReviews;
  final List<ProductVariantDetail> productVariantDetails;
  final bool isDeleted;
  final bool isRecommended;
  final DateTime createdAt;
  final DateTime updatedAt;

  SearchProduct({
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
    required this.isRecommended,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) {
    return SearchProduct(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      basePrice: json['basePrice'].toDouble(),
      totalStock: json['totalStock'],
      images: List<String>.from(json['images']),
      isFeatured: json['isFeatured'],
      tags: List<String>.from(json['tags']),
      avgRating: json['avg_rating'].toDouble(),
      purchaseCount: json['purchaseCount'],
      viewCount: json['viewCount'],
      categoryId: Category.fromJson(json['categoryId']),
      subcategoryId: Subcategory.fromJson(json['subcategoryId']),
      shopId: Shop.fromJson(json['shopId']),
      brandId: Brand.fromJson(json['brandId']),
      createdBy: json['createdBy'],
      reviews: json['reviews'] ?? [],
      totalReviews: json['totalReviews'],
      productVariantDetails: List<ProductVariantDetail>.from(
        json['product_variant_Details'].map(
          (x) => ProductVariantDetail.fromJson(x),
        ),
      ),
      isDeleted: json['isDeleted'],
      isRecommended: json['isRecommended'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'product_variant_Details':
          productVariantDetails.map((x) => x.toJson()).toList(),
      'isDeleted': isDeleted,
      'isRecommended': isRecommended,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ProductVariantDetail {
  final ProductVariant variantId;
  final int variantQuantity;
  final double variantPrice;

  ProductVariantDetail({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) {
    return ProductVariantDetail(
      variantId: ProductVariant.fromJson(json['variantId']),
      variantQuantity: json['variantQuantity'],
      variantPrice: json['variantPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId.toJson(),
      'variantQuantity': variantQuantity,
      'variantPrice': variantPrice,
    };
  }
}

class ProductVariant {
  final String id;
  final String slug;
  final String variantId;

  ProductVariant({
    required this.id,
    required this.slug,
    required this.variantId,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['_id'],
      slug: json['slug'],
      variantId: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'slug': slug, 'id': variantId};
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Subcategory {
  final String id;
  final String name;

  Subcategory({required this.id, required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Shop {
  final String id;
  final String name;

  Shop({required this.id, required this.name});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class Brand {
  final String id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}
