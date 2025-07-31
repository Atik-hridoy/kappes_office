class ProductVariantDetail {
  String variantId;
  num variantQuantity;
  num variantPrice;

  ProductVariantDetail({
    required this.variantId,
    required this.variantQuantity,
    required this.variantPrice,
  });

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) {
    return ProductVariantDetail(
      variantId: json['variantId'] ?? '',
      variantQuantity: json['variantQuantity'] ?? 0,
      variantPrice: json['variantPrice'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'variantQuantity': variantQuantity,
      'variantPrice': variantPrice,
    };
  }
}

class Product {
  String id;
  String name;
  String description;
  double basePrice;
  num totalStock;
  List<String> images;
  bool isFeatured;
  List<String> tags;
  double avgRating;
  num purchaseCount;
  num viewCount;
  String categoryId;
  String subcategoryId;
  String shopId;
  String brandId;
  String createdBy;
  List<dynamic> reviews;
  int totalReviews;
  List<ProductVariantDetail> productVariantDetails;
  bool isDeleted;
  bool isRecommended;
  String createdAt;
  String updatedAt;

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
    required this.isRecommended,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var productVariants =
        (json['product_variant_Details'] as List)
            .map((item) => ProductVariantDetail.fromJson(item))
            .toList();

    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: json['basePrice']?.toDouble() ?? 0.0,
      totalStock: json['totalStock'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      isFeatured: json['isFeatured'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      avgRating: json['avg_rating']?.toDouble() ?? 0.0,
      purchaseCount: json['purchaseCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      subcategoryId: json['subcategoryId'] ?? '',
      shopId: json['shopId'] ?? '',
      brandId: json['brandId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      reviews: json['reviews'] ?? [],
      totalReviews: json['totalReviews'] ?? 0,
      productVariantDetails: productVariants,
      isDeleted: json['isDeleted'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
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
      'isRecommended': isRecommended,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SavedModel {
  Product product;
  String id;
  String addedAt;

  SavedModel({required this.product, required this.id, required this.addedAt});

  factory SavedModel.fromJson(Map<String, dynamic> json) {
    return SavedModel(
      product: Product.fromJson(json['product']),
      id: json['_id'] ?? '',
      addedAt: json['addedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), '_id': id, 'addedAt': addedAt};
  }
}
