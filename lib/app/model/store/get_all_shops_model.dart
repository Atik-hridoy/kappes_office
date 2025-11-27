class ShopByStore {
  final bool success;
  final String message;
  final ShopData data;

  ShopByStore({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ShopByStore.fromJson(Map<String, dynamic> json) {
    return ShopByStore(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ShopData.fromJson((json['data'] ?? const {})),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

class ShopData {
  final Meta meta;
  final List<Shop> result;

  ShopData({
    required this.meta,
    required this.result,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      meta: Meta.fromJson((json['meta'] ?? const {})),
      result: (json['result'] as List<dynamic>?)
              ?.map((item) => Shop.fromJson((item as Map<String, dynamic>? ?? const {})))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'meta': meta.toJson(),
        'result': result.map((item) => item.toJson()).toList(),
      };
}

class Meta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Meta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'limit': limit,
        'page': page,
        'totalPage': totalPage,
      };
}

class Shop {
  final Address address;
  final Location location;
  final ShopSettings settings;
  final String id;
  final String name;
  final List<String> categories;
  final Owner owner;
  final String phone;
  final String email;
  final bool isDeleted;
  final bool isActive;
  final String type;
  final String description;
  final List<WorkingHour> workingHours;
  final String? logo;
  final String? coverPhoto;
  final String? banner;
  final String website;
  final double rating;
  final int totalReviews;
  final int totalFollowers;
  final String createdAt;
  final String updatedAt;
  final double revenue;

  Shop({
    required this.address,
    required this.location,
    required this.settings,
    required this.id,
    required this.name,
    required this.categories,
    required this.owner,
    required this.phone,
    required this.email,
    required this.isDeleted,
    required this.isActive,
    required this.type,
    required this.description,
    required this.workingHours,
    this.logo,
    this.coverPhoto,
    this.banner,
    required this.website,
    required this.rating,
    required this.totalReviews,
    required this.totalFollowers,
    required this.createdAt,
    required this.updatedAt,
    required this.revenue,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      address: Address.fromJson((json['address'] ?? const {})),
      location: Location.fromJson((json['location'] ?? const {})),
      settings: ShopSettings.fromJson((json['settings'] ?? const {})),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      owner: Owner.fromJson((json['owner'] ?? const {})),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      isActive: json['isActive'] ?? false,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      workingHours: (json['working_hours'] as List<dynamic>?)
              ?.map((item) => WorkingHour.fromJson(item))
              .toList() ??
          [],
      logo: _normalizeMediaValue(json['logo']),
      coverPhoto: _normalizeMediaValue(json['coverPhoto']),
      banner: _normalizeMediaValue(json['banner']),
      website: json['website'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      totalFollowers: json['totalFollowers'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      revenue: json['revenue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address.toJson(),
        'location': location.toJson(),
        'settings': settings.toJson(),
        '_id': id,
        'name': name,
        'categories': categories,
        'owner': owner.toJson(),
        'phone': phone,
        'email': email,
        'isDeleted': isDeleted,
        'isActive': isActive,
        'type': type,
        'description': description,
        'working_hours': workingHours.map((item) => item.toJson()).toList(),
        'logo': logo,
        'coverPhoto': coverPhoto,
        'banner': banner,
        'website': website,
        'rating': rating,
        'totalReviews': totalReviews,
        'totalFollowers': totalFollowers,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'revenue': revenue,
      };

  static String? _normalizeMediaValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is String) return first;
    }
    return null;
  }
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      territory: json['territory'] ?? '',
      country: json['country'] ?? '',
      detailAddress: json['detail_address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'province': province,
        'city': city,
        'territory': territory,
        'country': country,
        'detail_address': detailAddress,
      };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] is List)
          ? (json['coordinates'] as List).map((e) => (e as num).toDouble()).toList()
          : <double>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}

class ShopSettings {
  final bool allowChat;
  final bool autoAcceptOrders;

  ShopSettings({
    required this.allowChat,
    required this.autoAcceptOrders,
  });

  factory ShopSettings.fromJson(Map<String, dynamic> json) {
    return ShopSettings(
      allowChat: json['allowChat'] ?? false,
      autoAcceptOrders: json['autoAcceptOrders'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'allowChat': allowChat,
        'autoAcceptOrders': autoAcceptOrders,
      };
}

class Owner {
  final String id;
  final String fullName;
  final String email;

  Owner({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'full_name': fullName,
        'email': email,
      };
}

class WorkingHour {
  final String day;
  final String start;
  final String end;
  final String id;

  WorkingHour({
    required this.day,
    required this.start,
    required this.end,
    required this.id,
  });

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      day: json['day'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'start': start,
        'end': end,
        'id': id,
      };
}
