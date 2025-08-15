class ProvinceStore {
  final bool success;
  final String message;
  final List<ProvinceData> data;

  ProvinceStore({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProvinceStore.fromJson(Map<String, dynamic> json) {
    return ProvinceStore(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ProvinceData.fromJson(item))
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

class ProvinceData {
  final String? province;
  final int productCount;

  ProvinceData({
    this.province,
    required this.productCount,
  });

  factory ProvinceData.fromJson(Map<String, dynamic> json) {
    return ProvinceData(
      province: json['province'] as String?,
      productCount: json['productCount'] as int? ?? 0, // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() => {
        'province': province,
        'productCount': productCount,
      };
}
