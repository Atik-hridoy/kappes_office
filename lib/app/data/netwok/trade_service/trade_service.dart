import 'package:dio/dio.dart';
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class Business {
  final String id;
  final String name;
  final String logo;
  final String service;
  final String location;
  final String phone;
  final String email;
  final bool isVerified;
  final String description;
  final double rating;
  final int reviewCount;
  final String type;
  final BusinessAddress address;
  final List<WorkingHour> workingHours;

  Business({
    required this.id,
    required this.name,
    required this.logo,
    required this.service,
    required this.location,
    required this.phone,
    required this.email,
    required this.isVerified,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.type,
    required this.address,
    required this.workingHours,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    final addressData = json['address'] as Map<String, dynamic>?;
    return Business(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      location: '${addressData?['city']?.toString() ?? ''}, ${addressData?['province']?.toString() ?? ''}',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isVerified: json['verified'] ?? false,
      description: json['description']?.toString() ?? '',
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['totalReviews'] as int? ?? 0,
      type: json['type']?.toString() ?? '',
      address: BusinessAddress.fromJson(addressData ?? {}),
      workingHours: (json['working_hours'] as List<dynamic>?)
          ?.map((e) => WorkingHour.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'logo': logo,
      'service': service,
      'location': location,
      'phone': phone,
      'email': email,
      'isVerified': isVerified,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'type': type,
      'address': address.toJson(),
      'working_hours': workingHours.map((e) => e.toJson()).toList(),
    };
  }
}

class BusinessAddress {
  final String province;
  final String city;
  final String territory;
  final String country;
  final String detailAddress;

  BusinessAddress({
    required this.province,
    required this.city,
    required this.territory,
    required this.country,
    required this.detailAddress,
  });

  factory BusinessAddress.fromJson(Map<String, dynamic> json) {
    return BusinessAddress(
      province: json['province']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      territory: json['territory']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      detailAddress: json['detail_address']?.toString() ?? '',
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

class WorkingHour {
  final String day;
  final String start;
  final String end;

  WorkingHour({
    required this.day,
    required this.start,
    required this.end,
  });

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      day: json['day']?.toString() ?? '',
      start: json['start']?.toString() ?? '',
      end: json['end']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start': start,
      'end': end,
    };
  }
}

class TradeServiceResponse {
  final bool success;
  final String message;
  final List<Business> data;

  TradeServiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TradeServiceResponse.fromJson(Map<String, dynamic> json) {
    return TradeServiceResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: (json['data']?['businesses'] as List<dynamic>?)
          ?.map((e) => Business.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class TradeService {
  static Future<TradeServiceResponse> getAllVerifiedBusinesses() async {
    final dio = Dio();
    
    try {
      AppLogger.info('Fetching all verified businesses...', tag: 'TRADE_SERVICE');
      
      final response = await dio.get('${AppUrls.baseUrl}${AppUrls.getAllVerifiedBusinesses}');
      
      AppLogger.info('Response received: ${response.statusCode}', tag: 'TRADE_SERVICE');
      AppLogger.info('Response body: ${response.data}', tag: 'TRADE_SERVICE');
      
      if (response.statusCode == 200) {
        final responseData = TradeServiceResponse.fromJson(response.data);
        AppLogger.info('Successfully fetched ${responseData.data.length} businesses', tag: 'TRADE_SERVICE');
        return responseData;
      } else {
        AppLogger.error('Failed to fetch businesses: ${response.statusCode}', tag: 'TRADE_SERVICE', error: 'HTTP Error ${response.statusCode}');
        return TradeServiceResponse(
          success: false,
          message: 'Failed to fetch businesses: ${response.statusCode}',
          data: [],
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching businesses: $e', tag: 'TRADE_SERVICE', error: e);
      AppLogger.error(stackTrace.toString(), tag: 'TRADE_SERVICE', error: stackTrace);
      return TradeServiceResponse(
        success: false,
        message: 'Error fetching businesses: $e',
        data: [],
      );
    }
  }

  static Future<Business> getBusinessById(String businessId) async {
    final dio = Dio();
    
    try {
      AppLogger.info('Fetching business details for ID: $businessId', tag: 'TRADE_SERVICE');
      
      final response = await dio.get('${AppUrls.baseUrl}${AppUrls.getBusinessById}$businessId');
      
      AppLogger.info('Response received: ${response.statusCode}', tag: 'TRADE_SERVICE');
      AppLogger.info('Response body: ${response.data}', tag: 'TRADE_SERVICE');
      
      if (response.statusCode == 200) {
        final business = Business.fromJson(response.data);
        AppLogger.info('Successfully fetched business: ${business.name}', tag: 'TRADE_SERVICE');
        return business;
      } else {
        AppLogger.error('Failed to fetch business: ${response.statusCode}', tag: 'TRADE_SERVICE', error: 'HTTP Error ${response.statusCode}');
        throw Exception('Failed to fetch business: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching business details: $e', tag: 'TRADE_SERVICE', error: e);
      AppLogger.error(stackTrace.toString(), tag: 'TRADE_SERVICE', error: stackTrace);
      throw Exception('Error fetching business details: $e');
    }
  }

  static Future<bool> sendMessageToBusiness(String businessId, {
    required String message,
    required String senderName,
    required String senderEmail,
  }) async {
    final dio = Dio();
    
    try {
      AppLogger.info('Sending message to business: $businessId', tag: 'TRADE_SERVICE');
      
      final response = await dio.post(
        '${AppUrls.baseUrl}${AppUrls.getBusinessMessage}$businessId',
        data: {
          'message': message,
          'senderName': senderName,
          'senderEmail': senderEmail,
        },
      );
      
      AppLogger.info('Message response received: ${response.statusCode}', tag: 'TRADE_SERVICE');
      AppLogger.info('Response body: ${response.data}', tag: 'TRADE_SERVICE');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Message sent successfully', tag: 'TRADE_SERVICE');
        return true;
      } else {
        AppLogger.error('Failed to send message: ${response.statusCode}', tag: 'TRADE_SERVICE', error: 'HTTP Error ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error sending message: $e', tag: 'TRADE_SERVICE', error: e);
      AppLogger.error(stackTrace.toString(), tag: 'TRADE_SERVICE', error: stackTrace);
      return false;
    }
  }

  // Search businesses with search term
  static Future<TradeServiceResponse> searchBusinesses(String searchTerm) async {
    final dio = Dio();
    
    try {
      AppLogger.info('🔍 Searching businesses with term: $searchTerm', tag: 'TRADE_SERVICE');
      
      final response = await dio.get(
        '${AppUrls.baseUrl}${AppUrls.businessSearch}',
        queryParameters: {'searchTerm': searchTerm},
      );
      
      AppLogger.info('🔍 Business search response received: ${response.statusCode}', tag: 'TRADE_SERVICE');
      AppLogger.info('🔍 Business search response body: ${response.data}', tag: 'TRADE_SERVICE');
      
      if (response.statusCode == 200) {
        final responseData = TradeServiceResponse.fromJson(response.data);
        AppLogger.info('🟢 Successfully searched businesses: ${responseData.data.length} results', tag: 'TRADE_SERVICE');
        return responseData;
      } else {
        AppLogger.error('🔴 Failed to search businesses: ${response.statusCode}', tag: 'TRADE_SERVICE', error: 'HTTP Error ${response.statusCode}');
        return TradeServiceResponse(
          success: false,
          message: 'Failed to search businesses: ${response.statusCode}',
          data: [],
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('🔴 Error searching businesses: $e', tag: 'TRADE_SERVICE', error: e);
      AppLogger.error(stackTrace.toString(), tag: 'TRADE_SERVICE', error: stackTrace);
      return TradeServiceResponse(
        success: false,
        message: 'Error searching businesses: $e',
        data: [],
      );
    }
  }

  // Get all businesses (without search term)
  static Future<TradeServiceResponse> getAllBusinesses() async {
    final dio = Dio();
    
    try {
      AppLogger.info('🟢 Fetching all businesses', tag: 'TRADE_SERVICE');
      
      final response = await dio.get('${AppUrls.baseUrl}${AppUrls.businessSearch}');
      
      AppLogger.info('🟢 All businesses response received: ${response.statusCode}', tag: 'TRADE_SERVICE');
      AppLogger.info('🟢 All businesses response body: ${response.data}', tag: 'TRADE_SERVICE');
      
      if (response.statusCode == 200) {
        final responseData = TradeServiceResponse.fromJson(response.data);
        AppLogger.info('🟢 Successfully fetched all businesses: ${responseData.data.length} results', tag: 'TRADE_SERVICE');
        return responseData;
      } else {
        AppLogger.error('🔴 Failed to fetch all businesses: ${response.statusCode}', tag: 'TRADE_SERVICE', error: 'HTTP Error ${response.statusCode}');
        return TradeServiceResponse(
          success: false,
          message: 'Failed to fetch all businesses: ${response.statusCode}',
          data: [],
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('🔴 Error fetching all businesses: $e', tag: 'TRADE_SERVICE', error: e);
      AppLogger.error(stackTrace.toString(), tag: 'TRADE_SERVICE', error: stackTrace);
      return TradeServiceResponse(
        success: false,
        message: 'Error fetching all businesses: $e',
        data: [],
      );
    }
  }
}
