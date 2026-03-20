class BookingModel {
  final String id;
  final String serviceType;
  final String bookingDate;
  final String bookingTime;
  final String address;
  final String status;

  BookingModel({
    required this.id,
    required this.serviceType,
    required this.bookingDate,
    required this.bookingTime,
    required this.address,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      serviceType: json['service_type'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      bookingTime: json['booking_time'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }
}
