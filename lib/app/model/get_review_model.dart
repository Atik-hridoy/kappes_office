class GetReviewModel {
  final bool success;
  final String message;
  final ReviewData data;

  GetReviewModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetReviewModel.fromJson(Map<String, dynamic> json) {
    return GetReviewModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: ReviewData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class ReviewData {
  final Meta meta;
  final List<Review> result;

  ReviewData({required this.meta, required this.result});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
      result:
          (json['result'] as List? ?? [])
              .map((e) => Review.fromJson(e as Map<String, dynamic>? ?? {}))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'result': result.map((e) => e.toJson()).toList(),
    };
  }
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
      total: (json['total'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 0,
      totalPage: (json['totalPage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }
}

class Review {
  final String id;
  final Customer customer;
  final String comment;
  final double rating;
  final String? refferenceId;
  final String reviewType;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final bool isApproved;
  final List<String> images;

  Review({
    required this.id,
    required this.customer,
    required this.comment,
    required this.rating,
    this.refferenceId,
    required this.reviewType,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.isApproved,
    required this.images,
  });

  factory Review.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Review(
      id: json['_id'] as String? ?? '',
      customer: Customer.fromJson(
        json['customer'] as Map<String, dynamic>? ?? {},
      ),
      comment: json['comment'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      refferenceId: _parseReferenceId(json['refferenceId']),
      reviewType: json['review_type'] as String? ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: (json['__v'] as num?)?.toInt() ?? 0,
      isApproved: json['isApproved'] as bool? ?? false,
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }

  static String? _parseReferenceId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map) return value.toString();
    return value.toString();
  }

  static DateTime _parseDateTime(dynamic value) {
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customer': customer.toJson(),
      'comment': comment,
      'rating': rating,
      'refferenceId': refferenceId,
      'review_type': reviewType,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'isApproved': isApproved,
      'images': images,
    };
  }
}

class Customer {
  final String id;
  final String fullName;
  final String email;

  Customer({required this.id, required this.fullName, required this.email});

  factory Customer.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Customer(
      id: json['_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'full_name': fullName, 'email': email};
  }
}
