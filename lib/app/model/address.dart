class Shop {
  String id;
  String name;
  List<String> categories;
  String owner;
  String phone;
  String email;
  bool isDeleted;
  bool isActive;
  String type;
  String description;
  Address address;
  Location location;
  List<WorkingHour> workingHours;
  List<dynamic> reviews;
  List<dynamic> admins;
  List<dynamic> followers;
  List<dynamic> coupons;
  List<dynamic> chats;
  List<dynamic> orders;
  String website;
  int rating;
  int totalReviews;
  int totalFollowers;
  Settings settings;
  String createdAt;
  String updatedAt;
  int distance;

  Shop({
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
    required this.address,
    required this.location,
    required this.workingHours,
    required this.reviews,
    required this.admins,
    required this.followers,
    required this.coupons,
    required this.chats,
    required this.orders,
    required this.website,
    required this.rating,
    required this.totalReviews,
    required this.totalFollowers,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    required this.distance,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'],
      name: json['name'],
      categories: List<String>.from(json['categories']),
      owner: json['owner'],
      phone: json['phone'],
      email: json['email'],
      isDeleted: json['isDeleted'],
      isActive: json['isActive'],
      type: json['type'],
      description: json['description'],
      address: Address.fromJson(json['address']),
      location: Location.fromJson(json['location']),
      workingHours: List<WorkingHour>.from(
        json['working_hours'].map((x) => WorkingHour.fromJson(x)),
      ),
      reviews: List<dynamic>.from(json['reviews']),
      admins: List<dynamic>.from(json['admins']),
      followers: List<dynamic>.from(json['followers']),
      coupons: List<dynamic>.from(json['coupons']),
      chats: List<dynamic>.from(json['chats']),
      orders: List<dynamic>.from(json['orders']),
      website: json['website'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
      totalFollowers: json['totalFollowers'],
      settings: Settings.fromJson(json['settings']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'categories': categories,
      'owner': owner,
      'phone': phone,
      'email': email,
      'isDeleted': isDeleted,
      'isActive': isActive,
      'type': type,
      'description': description,
      'address': address.toJson(),
      'location': location.toJson(),
      'working_hours': workingHours.map((x) => x.toJson()).toList(),
      'reviews': reviews,
      'admins': admins,
      'followers': followers,
      'coupons': coupons,
      'chats': chats,
      'orders': orders,
      'website': website,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalFollowers': totalFollowers,
      'settings': settings.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'distance': distance,
    };
  }
}

class Address {
  String province;
  String city;
  String territory;
  String country;
  String detailAddress;

  Address({
    required this.province,
    required this.city,
    required this.territory,
    required this.country,
    required this.detailAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      province: json['province'],
      city: json['city'],
      territory: json['territory'],
      country: json['country'],
      detailAddress: json['detail_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'territory': territory,
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
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}

class WorkingHour {
  String day;
  String start;
  String end;

  WorkingHour({required this.day, required this.start, required this.end});

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      day: json['day'],
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'start': start, 'end': end};
  }
}

class Settings {
  bool allowChat;
  bool autoAcceptOrders;

  Settings({required this.allowChat, required this.autoAcceptOrders});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      allowChat: json['allowChat'],
      autoAcceptOrders: json['autoAcceptOrders'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'allowChat': allowChat, 'autoAcceptOrders': autoAcceptOrders};
  }
}
