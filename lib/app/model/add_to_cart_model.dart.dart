class AddToCartModel {
  final bool success;
  final String message;
  final CartData? data;

  AddToCartModel({required this.success, required this.message, this.data});

  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return AddToCartModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }
}

class CartData {
  final Cart? cart;
  final double total;

  CartData({this.cart, required this.total});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = <CartItem>[];
    if (json['items'] != null) {
      itemsList =
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList();
    }

    return Cart(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      items: itemsList,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
}

class CartItem {
  final Product? productId;
  final Variant? variantId;
  final double variantPrice;
  final int variantQuantity;
  final double totalPrice;

  CartItem({
    this.productId,
    this.variantId,
    required this.variantPrice,
    required this.variantQuantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId:
          json['productId'] != null
              ? Product.fromJson(json['productId'])
              : null,
      variantId:
          json['variantId'] != null
              ? Variant.fromJson(json['variantId'])
              : null,
      variantPrice: (json['variantPrice'] ?? 0).toDouble(),
      variantQuantity: json['variantQuantity'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final List<String> images;

  Product({required this.id, required this.name, required this.images});

  factory Product.fromJson(Map<String, dynamic> json) {
    final imagesList =
        (json['images'] as List?)?.map((img) => img.toString()).toList() ?? [];

    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      images: imagesList,
    );
  }
}

class Variant {
  final String id;
  final String slug;

  Variant({required this.id, required this.slug});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(id: json['_id'] ?? '', slug: json['slug'] ?? '');
  }
}
