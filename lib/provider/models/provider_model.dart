class ProviderModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String profileImage;
  final List<String> services;
  final List<String> serviceAreas;
  final double rating;
  final int totalJobs;
  final int completedJobs;
  final double earnings;
  final String status;
  final DateTime joinedAt;

  ProviderModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.profileImage = '',
    this.services = const [],
    this.serviceAreas = const [],
    this.rating = 0.0,
    this.totalJobs = 0,
    this.completedJobs = 0,
    this.earnings = 0.0,
    this.status = 'offline',
    required this.joinedAt,
  });

  static ProviderModel demoProvider() {
    return ProviderModel(
      id: 'prov_001',
      name: 'Rajesh Kumar',
      phone: '+91 98765 43210',
      email: 'rajesh.k@blinklean.com',
      services: ['Home Cleaning', 'Kitchen Cleaning', 'Bathroom Cleaning'],
      serviceAreas: ['Vijayanagar', 'Rajajinagar', 'R.R Nagar'],
      rating: 4.8,
      totalJobs: 156,
      completedJobs: 148,
      earnings: 245600,
      status: 'online',
      joinedAt: DateTime(2024, 3, 15),
    );
  }
}
