// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'dart:convert';

CouponResponse couponResponseFromJson(String str) =>
    CouponResponse.fromJson(json.decode(str));

String couponResponseToJson(CouponResponse data) => json.encode(data.toJson());

@immutable
class CouponResponse {
  final bool success;
  final String message;
  final CouponData data;

  const CouponResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) => CouponResponse(
    success: json["success"] as bool,
    message: json["message"] as String,
    data: CouponData.fromJson(json["data"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponResponse &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          message == other.message &&
          data == other.data;

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}

@immutable
class CouponData {
  final Coupon coupon;
  final double discountedPrice;
  final double discountAmount;

  const CouponData({
    required this.coupon,
    required this.discountedPrice,
    required this.discountAmount,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
    coupon: Coupon.fromJson(json["coupon"] as Map<String, dynamic>),
    discountedPrice: (json["discountedPrice"] as num).toDouble(),
    discountAmount: (json["discountAmount"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "coupon": coupon.toJson(),
    "discountedPrice": discountedPrice,
    "discountAmount": discountAmount,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponData &&
          runtimeType == other.runtimeType &&
          coupon == other.coupon &&
          discountedPrice == other.discountedPrice &&
          discountAmount == other.discountAmount;

  @override
  int get hashCode =>
      coupon.hashCode ^ discountedPrice.hashCode ^ discountAmount.hashCode;
}

@immutable
class Coupon {
  final String id;
  final String code;
  final String shopId;
  final String discountType;
  final double discountValue;
  final double minOrderAmount;
  final double maxDiscountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String createdBy;

  const Coupon({
    required this.id,
    required this.code,
    required this.shopId,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    required this.maxDiscountAmount,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.createdBy,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["_id"] as String,
    code: json["code"] as String,
    shopId: json["shopId"] as String,
    discountType: json["discountType"] as String,
    discountValue: (json["discountValue"] as num).toDouble(),
    minOrderAmount: (json["minOrderAmount"] as num).toDouble(),
    maxDiscountAmount: (json["maxDiscountAmount"] as num).toDouble(),
    startDate: DateTime.parse(json["startDate"] as String),
    endDate: DateTime.parse(json["endDate"] as String),
    isActive: json["isActive"] as bool,
    isDeleted: json["isDeleted"] as bool,
    createdAt: DateTime.parse(json["createdAt"] as String),
    updatedAt: DateTime.parse(json["updatedAt"] as String),
    v: json["__v"] as int,
    createdBy: json["createdBy"] as String,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "code": code,
    "shopId": shopId,
    "discountType": discountType,
    "discountValue": discountValue,
    "minOrderAmount": minOrderAmount,
    "maxDiscountAmount": maxDiscountAmount,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "createdBy": createdBy,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coupon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          shopId == other.shopId &&
          discountType == other.discountType &&
          discountValue == other.discountValue &&
          minOrderAmount == other.minOrderAmount &&
          maxDiscountAmount == other.maxDiscountAmount &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          isActive == other.isActive &&
          isDeleted == other.isDeleted &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v &&
          createdBy == other.createdBy;

  @override
  int get hashCode =>
      id.hashCode ^
      code.hashCode ^
      shopId.hashCode ^
      discountType.hashCode ^
      discountValue.hashCode ^
      minOrderAmount.hashCode ^
      maxDiscountAmount.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      isActive.hashCode ^
      isDeleted.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode ^
      createdBy.hashCode;
}
