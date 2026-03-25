class BookingModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String serviceName;
  final String serviceCategory;
  final double price;
  final String scheduledDate;
  final String scheduledTime;
  final String status;
  final String paymentStatus;
  final String notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.serviceName,
    required this.serviceCategory,
    required this.price,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    this.paymentStatus = 'pending',
    this.notes = '',
    required this.createdAt,
  });

  static List<BookingModel> demoBookings() {
    return [
      BookingModel(
        id: 'BKN001',
        customerName: 'Priya Sharma',
        customerPhone: '+91 98765 12345',
        customerAddress: '123, 2nd Cross, Vijayanagar, Bengaluru',
        serviceName: '2BHK Deep Cleaning',
        serviceCategory: 'Home Cleaning',
        price: 2199,
        scheduledDate: 'Today',
        scheduledTime: '10:00 AM',
        status: 'upcoming',
        paymentStatus: 'paid',
        notes: 'Gate code: 1234',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      BookingModel(
        id: 'BKN002',
        customerName: 'Amit Patel',
        customerPhone: '+91 98765 54321',
        customerAddress: '45, 3rd Main, Rajajinagar, Bengaluru',
        serviceName: 'Kitchen Cleaning',
        serviceCategory: 'Home Cleaning',
        price: 1299,
        scheduledDate: 'Today',
        scheduledTime: '2:00 PM',
        status: 'upcoming',
        paymentStatus: 'pending',
        notes: '',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      BookingModel(
        id: 'BKN003',
        customerName: 'Sneha Reddy',
        customerPhone: '+91 98765 11111',
        customerAddress: '78, Park Road, R.R Nagar, Bengaluru',
        serviceName: 'Car Waterless Wash',
        serviceCategory: 'Vehicle Care',
        price: 299,
        scheduledDate: 'Tomorrow',
        scheduledTime: '9:00 AM',
        status: 'upcoming',
        paymentStatus: 'paid',
        notes: 'Silver Swift - Park in shade',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: 'BKN004',
        customerName: 'Vikram Singh',
        customerPhone: '+91 98765 22222',
        customerAddress: '12, 4th Cross, Chandra Layout, Bengaluru',
        serviceName: '1BHK Deep Cleaning',
        serviceCategory: 'Home Cleaning',
        price: 1499,
        scheduledDate: 'Yesterday',
        scheduledTime: '11:00 AM',
        status: 'completed',
        paymentStatus: 'paid',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: 'BKN005',
        customerName: 'Kavitha Nair',
        customerPhone: '+91 98765 33333',
        customerAddress: '56, 5th Main, Vijayanagar, Bengaluru',
        serviceName: 'Sofa Cleaning',
        serviceCategory: 'Home Cleaning',
        price: 1596,
        scheduledDate: 'Yesterday',
        scheduledTime: '3:00 PM',
        status: 'completed',
        paymentStatus: 'paid',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
