class DashboardStats {
  final int totalBookings;
  final int todayBookings;
  final int activeProviders;
  final int totalUsers;
  final double totalRevenue;
  final double monthlyRevenue;
  final double pendingPayouts;
  final double avgRating;

  DashboardStats({
    required this.totalBookings,
    required this.todayBookings,
    required this.activeProviders,
    required this.totalUsers,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.pendingPayouts,
    required this.avgRating,
  });

  static DashboardStats demo() {
    return DashboardStats(
      totalBookings: 4523,
      todayBookings: 127,
      activeProviders: 89,
      totalUsers: 2156,
      totalRevenue: 1284560,
      monthlyRevenue: 284500,
      pendingPayouts: 45600,
      avgRating: 4.8,
    );
  }
}

class BookingAdminModel {
  final String id;
  final String customerName;
  final String providerName;
  final String serviceName;
  final String serviceCategory;
  final double price;
  final String status;
  final String paymentStatus;
  final String scheduledDate;
  final String scheduledTime;
  final String customerPhone;
  final String providerPhone;
  final DateTime createdAt;

  BookingAdminModel({
    required this.id,
    required this.customerName,
    required this.providerName,
    required this.serviceName,
    required this.serviceCategory,
    required this.price,
    required this.status,
    required this.paymentStatus,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.customerPhone,
    required this.providerPhone,
    required this.createdAt,
  });

  static List<BookingAdminModel> demoBookings() {
    return [
      BookingAdminModel(
        id: 'BKN001',
        customerName: 'Priya Sharma',
        providerName: 'Rajesh Kumar',
        serviceName: '2BHK Deep Cleaning',
        serviceCategory: 'Home Cleaning',
        price: 2199,
        status: 'completed',
        paymentStatus: 'paid',
        scheduledDate: 'Today',
        scheduledTime: '10:00 AM',
        customerPhone: '+91 98765 12345',
        providerPhone: '+91 98765 43210',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      BookingAdminModel(
        id: 'BKN002',
        customerName: 'Amit Patel',
        providerName: 'Suresh Reddy',
        serviceName: 'Kitchen Cleaning',
        serviceCategory: 'Home Cleaning',
        price: 1299,
        status: 'upcoming',
        paymentStatus: 'pending',
        scheduledDate: 'Today',
        scheduledTime: '2:00 PM',
        customerPhone: '+91 98765 54321',
        providerPhone: '+91 98765 11111',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      BookingAdminModel(
        id: 'BKN003',
        customerName: 'Sneha Reddy',
        providerName: 'Rajesh Kumar',
        serviceName: 'Car Waterless Wash',
        serviceCategory: 'Vehicle Care',
        price: 299,
        status: 'in_progress',
        paymentStatus: 'paid',
        scheduledDate: 'Today',
        scheduledTime: '11:30 AM',
        customerPhone: '+91 98765 11111',
        providerPhone: '+91 98765 43210',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}

class ProviderAdminModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final List<String> services;
  final List<String> serviceAreas;
  final double rating;
  final int totalJobs;
  final int completedJobs;
  final double earnings;
  final String status;
  final DateTime joinedAt;
  final bool isVerified;

  ProviderAdminModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.services = const [],
    this.serviceAreas = const [],
    this.rating = 0.0,
    this.totalJobs = 0,
    this.completedJobs = 0,
    this.earnings = 0.0,
    this.status = 'offline',
    required this.joinedAt,
    this.isVerified = false,
  });

  static List<ProviderAdminModel> demoProviders() {
    return [
      ProviderAdminModel(
        id: 'prov_001',
        name: 'Rajesh Kumar',
        phone: '+91 98765 43210',
        email: 'rajesh.k@blinklean.com',
        services: ['Home Cleaning', 'Kitchen Cleaning', 'Bathroom Cleaning'],
        serviceAreas: ['Vijayanagar', 'Rajajinagar'],
        rating: 4.8,
        totalJobs: 156,
        completedJobs: 148,
        earnings: 245600,
        status: 'online',
        joinedAt: DateTime(2024, 3, 15),
        isVerified: true,
      ),
      ProviderAdminModel(
        id: 'prov_002',
        name: 'Suresh Reddy',
        phone: '+91 98765 11111',
        email: 'suresh.r@blinklean.com',
        services: ['Vehicle Care', 'Car Wash'],
        serviceAreas: ['R.R Nagar', 'Chandra Layout'],
        rating: 4.6,
        totalJobs: 89,
        completedJobs: 85,
        earnings: 125400,
        status: 'online',
        joinedAt: DateTime(2024, 5, 20),
        isVerified: true,
      ),
      ProviderAdminModel(
        id: 'prov_003',
        name: 'Mohan Rao',
        phone: '+91 98765 22222',
        email: 'mohan.r@blinklean.com',
        services: ['Laundry', 'Dry Cleaning'],
        serviceAreas: ['Vijayanagar'],
        rating: 4.9,
        totalJobs: 234,
        completedJobs: 230,
        earnings: 312800,
        status: 'offline',
        joinedAt: DateTime(2024, 1, 10),
        isVerified: true,
      ),
    ];
  }
}

class UserAdminModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int totalBookings;
  final double totalSpent;
  final String status;
  final DateTime joinedAt;
  final DateTime lastBooking;

  UserAdminModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.totalBookings = 0,
    this.totalSpent = 0.0,
    this.status = 'active',
    required this.joinedAt,
    required this.lastBooking,
  });

  static List<UserAdminModel> demoUsers() {
    return [
      UserAdminModel(
        id: 'user_001',
        name: 'Priya Sharma',
        phone: '+91 98765 12345',
        email: 'priya.s@email.com',
        totalBookings: 12,
        totalSpent: 18500,
        status: 'active',
        joinedAt: DateTime(2024, 2, 15),
        lastBooking: DateTime.now().subtract(const Duration(days: 2)),
      ),
      UserAdminModel(
        id: 'user_002',
        name: 'Amit Patel',
        phone: '+91 98765 54321',
        email: 'amit.p@email.com',
        totalBookings: 8,
        totalSpent: 12400,
        status: 'active',
        joinedAt: DateTime(2024, 4, 20),
        lastBooking: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
