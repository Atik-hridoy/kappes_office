class CreateCartOrder {
  final String? id;
  final String? userId;
  final List<CartItem>? items;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? price; // add price here
  // add userId here
  final List<Variant>? variants;

  CreateCartOrder({
    this.id,
    this.userId,
    this.items,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.variants,
  });

  factory CreateCartOrder.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CreateCartOrder();

    var itemsJson = json['items'] as List<dynamic>?;
    List<CartItem>? itemsList =
        itemsJson
            ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>?))
            .toList();

    return CreateCartOrder(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      items: itemsList,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  /// Converts the CreateCartOrder instance into a map of key-value pairs
  /// where each key corresponds to a field name and its associated value.
  ///
  /// Returns a Map<String, dynamic> containing:
  /// - '_id': the order ID
  /// - 'userId': the ID of the user who created the order
  /// - 'items': a list of cart items converted to JSON
  /// - 'createdAt': the ISO 8601 string representation of the creation date
  /// - 'updatedAt': the ISO 8601 string representation of the update date

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'items': items?.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class CartItem {
  final Product? product;
  final Variant? variant;
  final int? variantPrice;
  final int? variantQuantity;
  final int? totalPrice;

  CartItem({
    this.product,
    this.variant,
    this.variantPrice,
    this.variantQuantity,
    this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CartItem();

    return CartItem(
      product: Product.fromJson(json['productId'] as Map<String, dynamic>?),
      variant: Variant.fromJson(json['variantId'] as Map<String, dynamic>?),
      variantPrice: json['variantPrice'] as int?,
      variantQuantity: json['variantQuantity'] as int?,
      totalPrice: json['totalPrice'] as int?,
    );
  }

  /// Converts the CartItem instance into a map of key-value pairs
  /// where each key corresponds to a field name and its associated value.
  ///
  // ignore: unintended_html_in_doc_comment
  /// Returns a Map<String, dynamic> containing:
  /// - 'productId': the product ID converted to JSON
  /// - 'variantId': the variant ID converted to JSON
  /// - 'variantPrice': the price of the variant
  /// - 'variantQuantity': the quantity of the variant in the cart
  /// - 'totalPrice': the total price of the variant in the cart
  Map<String, dynamic> toJson() {
    return {
      'productId': product?.toJson(),
      'variantId': variant?.toJson(),
      'variantPrice': variantPrice,
      'variantQuantity': variantQuantity,
      'totalPrice': totalPrice,
    };
  }
}

class Product {
  final String? id;
  final String? name;
  final List<String>? images;

  Product({this.id, this.name, this.images});

  factory Product.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Product();

    var imagesList =
        json['images'] != null ? List<String>.from(json['images']) : null;

    return Product(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      images: imagesList,
    );
  }

  /// Converts the Product instance into a map of key-value pairs
  /// where each key corresponds to a field name and its associated value.
  ///
  /// Returns a Map<String, dynamic> containing:
  /// - '_id': the product ID
  /// - 'name': the name of the product
  /// - 'images': a list of image URLs related to the product

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'images': images};
  }
}

class Variant {
  final String? id;
  final String? slug;

  Variant({this.id, this.slug});

  factory Variant.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Variant();

    return Variant(id: json['_id'] as String?, slug: json['slug'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'slug': slug};
  }
}
