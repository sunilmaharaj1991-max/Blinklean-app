class BookingModel {
  final String id;
  final String? userId;
  final String? serviceId;
  final String serviceType;
  final String? userName;
  final String? contactPhone;
  final String address;
  final String bookingDate;
  final String bookingTime;
  final double amount;
  final String status;
  final String? paymentId;
  final String? paymentStatus;
  final String? notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    this.userId,
    this.serviceId,
    required this.serviceType,
    this.userName,
    this.contactPhone,
    required this.address,
    required this.bookingDate,
    required this.bookingTime,
    this.amount = 0,
    this.status = 'Pending',
    this.paymentId,
    this.paymentStatus,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      userId: json['user_id'],
      serviceId: json['service_id'],
      serviceType: json['service_name'] ?? json['service_type'] ?? '',
      userName: json['user_name'],
      contactPhone: json['contact_phone'],
      address: json['address'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      bookingTime: json['booking_time'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      paymentId: json['payment_id'],
      paymentStatus: json['payment_status'],
      notes: json['notes'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'service_name': serviceType,
      'user_name': userName,
      'contact_phone': contactPhone,
      'address': address,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'amount': amount,
      'status': status,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'notes': notes,
    };
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(bookingDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return bookingDate;
    }
  }

  bool get isPending => status == 'Pending';
  bool get isCompleted => status == 'Completed';
  bool get isCancelled => status == 'Cancelled';
}
