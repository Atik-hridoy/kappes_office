class ContactResponse {
  final bool success;
  final String message;
  final List<Contact> data;

  ContactResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List? ?? [])
          .map((contactJson) => Contact.fromJson(contactJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((contact) => contact.toJson()).toList(),
  };
}

class Contact {
  final String id;
  final String phone;
  final String email;
  final String location;

  Contact({
    required this.id,
    required this.phone,
    required this.email,
    required this.location,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['_id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'phone': phone,
    'email': email,
    'location': location,
  };

  // For UI display
  String get displayPhone => _formatPhoneNumber(phone);

  static String _formatPhoneNumber(String phone) {
    // Format: 123-456-7890 → (123) 456-7890
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return phone;
  }
}