class Territory {
  final bool success;
  final String message;
  final List<TerritoryData> data;

  Territory({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Territory.fromJson(Map<String, dynamic> json) {
    return Territory(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => TerritoryData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((item) => item.toJson()).toList(),
      };
}

class TerritoryData {
  final String? province;
  final int productCount;

  TerritoryData({
    this.province,
    required this.productCount,
  });

  factory TerritoryData.fromJson(Map<String, dynamic> json) {
    return TerritoryData(
      province: json['province'] as String?,
      productCount: json['productCount'] as int? ?? 0, // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() => {
        'province': province,
        'productCount': productCount,
      };
}
