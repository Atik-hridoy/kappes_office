import 'package:meta/meta.dart';
import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

@immutable
class CategoryResponse {
  final bool success;
  final String message;
  final CategoryData data;

  const CategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        success: json["success"] as bool? ?? false,
        message: json["message"] as String? ?? "",
        data: CategoryData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryResponse &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          message == other.message &&
          data == other.data;

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}

@immutable
class CategoryData {
  final List<Category> categories;
  final Meta meta;

  const CategoryData({required this.categories, required this.meta});

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    categories: List<Category>.from(
      (json["categorys"] as List<dynamic>? ?? []).map(
        (x) => Category.fromJson(x as Map<String, dynamic>),
      ),
    ),
    meta: Meta.fromJson(json["meta"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "categorys": List<dynamic>.from(categories.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryData &&
          runtimeType == other.runtimeType &&
          categories == other.categories &&
          meta == other.meta;

  @override
  int get hashCode => categories.hashCode ^ meta.hashCode;
}

@immutable
class Category {
  final String id;
  final String name;
  final String thumbnail;
  final String createdBy;
  final List<SubCategory> subCategories;
  final String description;
  final String status;
  final bool isDeleted;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.createdBy,
    required this.subCategories,
    required this.description,
    required this.status,
    required this.isDeleted,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"] as String? ?? "",
    name: json["name"] as String? ?? "",
    thumbnail: json["thumbnail"] as String? ?? "",
    createdBy: json["createdBy"] as String? ?? "",
    subCategories: List<SubCategory>.from(
      (json["subCategory"] as List<dynamic>? ?? []).map(
        (x) => SubCategory.fromJson(x as Map<String, dynamic>),
      ),
    ),
    description: json["description"] as String? ?? "",
    status: json["status"] as String? ?? "inactive",
    isDeleted: json["isDeleted"] as bool? ?? false,
    viewCount: (json["ctgViewCount"] as int?) ?? 0,
    createdAt: DateTime.parse(
      json["createdAt"] as String? ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json["updatedAt"] as String? ?? DateTime.now().toIso8601String(),
    ),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "thumbnail": thumbnail,
    "createdBy": createdBy,
    "subCategory": List<dynamic>.from(subCategories.map((x) => x.toJson())),
    "description": description,
    "status": status,
    "isDeleted": isDeleted,
    "ctgViewCount": viewCount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          thumbnail == other.thumbnail &&
          createdBy == other.createdBy &&
          subCategories == other.subCategories &&
          description == other.description &&
          status == other.status &&
          isDeleted == other.isDeleted &&
          viewCount == other.viewCount &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      thumbnail.hashCode ^
      createdBy.hashCode ^
      subCategories.hashCode ^
      description.hashCode ^
      status.hashCode ^
      isDeleted.hashCode ^
      viewCount.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

@immutable
class SubCategory {
  final String id;
  final String name;

  const SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["_id"] as String? ?? "",
    name: json["name"] as String? ?? "",
  );

  Map<String, dynamic> toJson() => {"_id": id, "name": name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

@immutable
class Meta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  const Meta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: (json["total"] as int?) ?? 0,
    limit: (json["limit"] as int?) ?? 10,
    page: (json["page"] as int?) ?? 1,
    totalPage: (json["totalPage"] as int?) ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "limit": limit,
    "page": page,
    "totalPage": totalPage,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meta &&
          runtimeType == other.runtimeType &&
          total == other.total &&
          limit == other.limit &&
          page == other.page &&
          totalPage == other.totalPage;

  @override
  int get hashCode =>
      total.hashCode ^ limit.hashCode ^ page.hashCode ^ totalPage.hashCode;
}
