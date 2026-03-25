class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? pincode;
  final String? deviceToken;
  final int bookingsCount;
  final double totalSpent;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.pincode,
    this.deviceToken,
    this.bookingsCount = 0,
    this.totalSpent = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      pincode: json['pincode'],
      deviceToken: json['device_token'],
      bookingsCount: json['bookings_count'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'pincode': pincode,
      'device_token': deviceToken,
      'bookings_count': bookingsCount,
      'total_spent': totalSpent,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? pincode,
    String? deviceToken,
    int? bookingsCount,
    double? totalSpent,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      deviceToken: deviceToken ?? this.deviceToken,
      bookingsCount: bookingsCount ?? this.bookingsCount,
      totalSpent: totalSpent ?? this.totalSpent,
      createdAt: createdAt,
    );
  }
}
