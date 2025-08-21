class ShippingDetails {
  bool success;
  String message;
  ShippingData data;

  ShippingDetails({required this.success, required this.message, required this.data});

  factory ShippingDetails.fromJson(Map<String, dynamic> json) {
    return ShippingDetails(
      success: json['success'],
      message: json['message'],
      data: ShippingData.fromJson(json['data']),
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

class ShippingData {
  ShippingType freeShipping;
  ShippingType centralShipping;
  ShippingType countryShipping;
  ShippingType worldWideShipping;

  ShippingData({
    required this.freeShipping,
    required this.centralShipping,
    required this.countryShipping,
    required this.worldWideShipping,
  });

  factory ShippingData.fromJson(Map<String, dynamic> json) {
    return ShippingData(
      freeShipping: ShippingType.fromJson(json['freeShipping']),
      centralShipping: ShippingType.fromJson(json['centralShipping']),
      countryShipping: ShippingType.fromJson(json['countryShipping']),
      worldWideShipping: ShippingType.fromJson(json['worldWideShipping']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'freeShipping': freeShipping.toJson(),
      'centralShipping': centralShipping.toJson(),
      'countryShipping': countryShipping.toJson(),
      'worldWideShipping': worldWideShipping.toJson(),
    };
  }
}

class ShippingType {
  List<String>? area;
  int cost;

  ShippingType({this.area, required this.cost});

  factory ShippingType.fromJson(Map<String, dynamic> json) {
    return ShippingType(
      area: json['area'] != null ? List<String>.from(json['area']) : null,
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'cost': cost,
    };
  }
}
