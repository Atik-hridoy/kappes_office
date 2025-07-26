class Shop {
  bool success;
  String message;
  ShopData? data;

  Shop({required this.success, required this.message, this.data});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ShopData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class ShopData {
  Address? address;
  Location? location;
  ShopSettings? settings;
  String id;
  String name;
  List<String> categories;
  Owner owner;
  String phone;
  String email;
  bool isDeleted;
  bool isActive;
  List<WorkingHour> workingHours;
  List<dynamic> reviews;
  List<dynamic> admins;
  List<dynamic> followers;
  List<dynamic> coupons;
  List<dynamic> chats;
  int rating;
  int totalReviews;
  int totalFollowers;
  DateTime createdAt;
  DateTime updatedAt;
  String coverPhoto;
  String banner;
  String description;
  String logo;
  String type;
  String website;
  String shopId;

  ShopData({
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
    required this.workingHours,
    required this.reviews,
    required this.admins,
    required this.followers,
    required this.coupons,
    required this.chats,
    required this.rating,
    required this.totalReviews,
    required this.totalFollowers,
    required this.createdAt,
    required this.updatedAt,
    required this.coverPhoto,
    required this.banner,
    required this.description,
    required this.logo,
    required this.type,
    required this.website,
    required this.shopId,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      settings:
          json['settings'] != null
              ? ShopSettings.fromJson(json['settings'])
              : null,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      owner:
          json['owner'] != null
              ? Owner.fromJson(json['owner'])
              : Owner(id: '', email: ''),
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      isActive: json['isActive'] ?? false,
      workingHours:
          (json['working_hours'] as List)
              .map((i) => WorkingHour.fromJson(i))
              .toList(),
      reviews: List<dynamic>.from(json['reviews'] ?? []),
      admins: List<dynamic>.from(json['admins'] ?? []),
      followers: List<dynamic>.from(json['followers'] ?? []),
      coupons: List<dynamic>.from(json['coupons'] ?? []),
      chats: List<dynamic>.from(json['chats'] ?? []),
      rating: json['rating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      totalFollowers: json['totalFollowers'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      coverPhoto: json['coverPhoto'] ?? '',
      banner: json['banner'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      type: json['type'] ?? '',
      website: json['website'] ?? '',
      shopId: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address?.toJson(),
      'location': location?.toJson(),
      'settings': settings?.toJson(),
      '_id': id,
      'name': name,
      'categories': categories,
      'owner': owner.toJson(),
      'phone': phone,
      'email': email,
      'isDeleted': isDeleted,
      'isActive': isActive,
      'working_hours': workingHours.map((i) => i.toJson()).toList(),
      'reviews': reviews,
      'admins': admins,
      'followers': followers,
      'coupons': coupons,
      'chats': chats,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalFollowers': totalFollowers,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'coverPhoto': coverPhoto,
      'banner': banner,
      'description': description,
      'logo': logo,
      'type': type,
      'website': website,
      'id': shopId,
    };
  }
}

class Owner {
  String id;
  String email;

  Owner({required this.id, required this.email});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(id: json['_id'] ?? '', email: json['email'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'email': email};
  }
}

class Address {
  String province;
  String territory;
  String city;
  String country;
  String detailAddress;

  Address({
    required this.province,
    required this.territory,
    required this.city,
    required this.country,
    required this.detailAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      province: json['province'] ?? '',
      territory: json['territory'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      detailAddress: json['detail_address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'territory': territory,
      'city': city,
      'country': country,
      'detail_address': detailAddress,
    };
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: List<double>.from(json['coordinates'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}

class ShopSettings {
  bool allowChat;
  bool autoAcceptOrders;
  List<dynamic> businessHours;

  ShopSettings({
    required this.allowChat,
    required this.autoAcceptOrders,
    required this.businessHours,
  });

  factory ShopSettings.fromJson(Map<String, dynamic> json) {
    return ShopSettings(
      allowChat: json['allowChat'] ?? false,
      autoAcceptOrders: json['autoAcceptOrders'] ?? false,
      businessHours: List<dynamic>.from(json['businessHours'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowChat': allowChat,
      'autoAcceptOrders': autoAcceptOrders,
      'businessHours': businessHours,
    };
  }
}

class WorkingHour {
  String day;
  String start;
  String end;

  WorkingHour({required this.day, required this.start, required this.end});

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      day: json['day'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'start': start, 'end': end};
  }
}
