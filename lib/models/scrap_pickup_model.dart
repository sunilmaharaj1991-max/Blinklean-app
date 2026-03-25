class ScrapPickupModel {
  final String id;
  final String? userId;
  final String? userName;
  final String? contactPhone;
  final String address;
  final String? pincode;
  final String? pickupDate;
  final String? pickupTime;
  final double estimatedValue;
  final String status;
  final String? notes;
  final List<Map<String, dynamic>> items;
  final DateTime createdAt;

  ScrapPickupModel({
    required this.id,
    this.userId,
    this.userName,
    this.contactPhone,
    required this.address,
    this.pincode,
    this.pickupDate,
    this.pickupTime,
    this.estimatedValue = 0,
    this.status = 'Pending',
    this.notes,
    this.items = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ScrapPickupModel.fromJson(Map<String, dynamic> json) {
    return ScrapPickupModel(
      id: json['id'] ?? '',
      userId: json['user_id'],
      userName: json['user_name'],
      contactPhone: json['contact_phone'],
      address: json['address'] ?? '',
      pincode: json['pincode'],
      pickupDate: json['pickup_date'],
      pickupTime: json['pickup_time'],
      estimatedValue: (json['estimated_value'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      notes: json['notes'],
      items: json['items'] != null 
          ? List<Map<String, dynamic>>.from(json['items']) 
          : [],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'contact_phone': contactPhone,
      'address': address,
      'pincode': pincode,
      'pickup_date': pickupDate,
      'pickup_time': pickupTime,
      'estimated_value': estimatedValue,
      'status': status,
      'notes': notes,
    };
  }

  bool get isPending => status == 'Pending';
  bool get isScheduled => status == 'Scheduled';
  bool get isCompleted => status == 'Completed';
}
