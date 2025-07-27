class GetCartModel {
  final bool success;
  final String message;
  final CartData? data;

  GetCartModel({required this.success, required this.message, this.data});

  factory GetCartModel.fromJson(Map<String, dynamic> json) {
    return GetCartModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'No message available',
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }
}

class CartData {
  final String? id;
  final String? userId;
  final List<CartItem>? items;

  CartData({this.id, this.userId, this.items});

  factory CartData.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List?;
    List<CartItem> itemsList = [];
    if (itemsJson != null) {
      itemsList = itemsJson.map((item) => CartItem.fromJson(item)).toList();
    }

    return CartData(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      items: itemsList,
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
      variantPrice: (json['variantPrice'] ?? 0.0).toDouble(),
      variantQuantity: json['variantQuantity'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }
}

class Product {
  final String? id;
  final String? name;
  final List<String>? images;
  final String? shopId;

  Product({this.id, this.name, this.images, this.shopId});

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List?;
    List<String> imagesList = [];
    if (imagesJson != null) {
      imagesList = imagesJson.map((image) => image.toString()).toList();
    }

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images: imagesList,
      shopId: json['shopId'] ?? '',
    );
  }
}

class Variant {
  final String? id;
  final String? colorName;
  final String? colorCode;
  final String? storage;
  final String? ram;
  final List<String>? networkType;
  final String? operatingSystem;

  Variant({
    this.id,
    this.colorName,
    this.colorCode,
    this.storage,
    this.ram,
    this.networkType,
    this.operatingSystem,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    var networkJson = json['network_type'] as List?;
    List<String> networkList = [];
    if (networkJson != null) {
      networkList = networkJson.map((type) => type.toString()).toList();
    }

    return Variant(
      id: json['_id'] ?? '',
      colorName: json['color'] != null ? json['color']['name'] : '',
      colorCode: json['color'] != null ? json['color']['code'] : '',
      storage: json['storage'] ?? '',
      ram: json['ram'] ?? '',
      networkType: networkList,
      operatingSystem: json['operating_system'] ?? '',
    );
  }
}
