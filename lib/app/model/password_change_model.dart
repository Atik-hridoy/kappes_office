import 'package:meta/meta.dart';
import 'dart:convert';

PasswordChangeResponse passwordChangeResponseFromJson(String str) =>
    PasswordChangeResponse.fromJson(json.decode(str));

String passwordChangeResponseToJson(PasswordChangeResponse data) =>
    json.encode(data.toJson());

@immutable
class PasswordChangeResponse {
  final bool success;
  final String message;
  final UserData data;

  const PasswordChangeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) =>
      PasswordChangeResponse(
        success: json["success"] as bool? ?? false,
        message: json["message"] as String? ?? "",
        data: UserData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordChangeResponse &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          message == other.message &&
          data == other.data;

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}

@immutable
class UserData {
  final String id;
  final String fullName;
  final String role;
  final String email;
  final String image;
  final String phone;
  final List<dynamic>
  businessInformations; // Can be typed more specifically if needed
  final String status;
  final bool verified;
  final bool isDeleted;
  final String stripeCustomerId;
  final int tokenVersion;
  final int loginCount;
  final DateTime joinDate;
  final List<dynamic>
  recentSearchLocations; // Can be typed more specifically if needed
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final DateTime lastLogin;

  const UserData({
    required this.id,
    required this.fullName,
    required this.role,
    required this.email,
    required this.image,
    required this.phone,
    required this.businessInformations,
    required this.status,
    required this.verified,
    required this.isDeleted,
    required this.stripeCustomerId,
    required this.tokenVersion,
    required this.loginCount,
    required this.joinDate,
    required this.recentSearchLocations,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.lastLogin,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["_id"] as String? ?? "",
    fullName: json["full_name"] as String? ?? "",
    role: json["role"] as String? ?? "USER",
    email: json["email"] as String? ?? "",
    image: json["image"] as String? ?? "",
    phone: json["phone"] as String? ?? "",
    businessInformations: json["business_informations"] as List<dynamic>? ?? [],
    status: json["status"] as String? ?? "inactive",
    verified: json["verified"] as bool? ?? false,
    isDeleted: json["isDeleted"] as bool? ?? false,
    stripeCustomerId: json["stripeCustomerId"] as String? ?? "",
    tokenVersion: (json["tokenVersion"] as int?) ?? 0,
    loginCount: (json["loginCount"] as int?) ?? 0,
    joinDate: DateTime.parse(
      json["joinDate"] as String? ?? DateTime.now().toIso8601String(),
    ),
    recentSearchLocations:
        json["recentSearchLocations"] as List<dynamic>? ?? [],
    createdAt: DateTime.parse(
      json["createdAt"] as String? ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json["updatedAt"] as String? ?? DateTime.now().toIso8601String(),
    ),
    version: (json["__v"] as int?) ?? 0,
    lastLogin: DateTime.parse(
      json["lastLogin"] as String? ?? DateTime.now().toIso8601String(),
    ),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "full_name": fullName,
    "role": role,
    "email": email,
    "image": image,
    "phone": phone,
    "business_informations": businessInformations,
    "status": status,
    "verified": verified,
    "isDeleted": isDeleted,
    "stripeCustomerId": stripeCustomerId,
    "tokenVersion": tokenVersion,
    "loginCount": loginCount,
    "joinDate": joinDate.toIso8601String(),
    "recentSearchLocations": recentSearchLocations,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": version,
    "lastLogin": lastLogin.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          role == other.role &&
          email == other.email &&
          image == other.image &&
          phone == other.phone &&
          businessInformations == other.businessInformations &&
          status == other.status &&
          verified == other.verified &&
          isDeleted == other.isDeleted &&
          stripeCustomerId == other.stripeCustomerId &&
          tokenVersion == other.tokenVersion &&
          loginCount == other.loginCount &&
          joinDate == other.joinDate &&
          recentSearchLocations == other.recentSearchLocations &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          version == other.version &&
          lastLogin == other.lastLogin;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      role.hashCode ^
      email.hashCode ^
      image.hashCode ^
      phone.hashCode ^
      businessInformations.hashCode ^
      status.hashCode ^
      verified.hashCode ^
      isDeleted.hashCode ^
      stripeCustomerId.hashCode ^
      tokenVersion.hashCode ^
      loginCount.hashCode ^
      joinDate.hashCode ^
      recentSearchLocations.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      version.hashCode ^
      lastLogin.hashCode;
}
