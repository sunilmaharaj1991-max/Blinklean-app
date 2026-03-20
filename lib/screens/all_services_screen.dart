import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_model.dart';
import '../core/app_theme.dart';
import 'service_detail_screen.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({super.key});

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  final List<ServiceModel> _services = [
    // Home Deep Cleaning
    ServiceModel(
      name: '1BHK Deep Cleaning',
      icon: Icons.home_work_rounded,
      description: 'Detailed floor-to-ceiling cleaning for compact living spaces.',
      estimatedDuration: '4-5 hrs',
      startingPrice: 1499,
      category: 'Home',
    ),
    ServiceModel(
      name: '2BHK Deep Cleaning',
      icon: Icons.apartment_rounded,
      description: 'Thorough deep clean including kitchen degreasing and bathroom scaling.',
      estimatedDuration: '6-7 hrs',
      startingPrice: 2199,
      category: 'Home',
    ),
    ServiceModel(
      name: '3BHK Deep Cleaning',
      icon: Icons.villa_rounded,
      description: 'Full-spectrum home detailing for large apartments.',
      estimatedDuration: '8-9 hrs',
      startingPrice: 2999,
      category: 'Home',
    ),
    ServiceModel(
      name: 'Kitchen Deep Cleaning',
      icon: Icons.kitchen_rounded,
      description: 'High-intensity degreasing for chimneys, cabinets, and tiles.',
      estimatedDuration: '3-4 hrs',
      startingPrice: 1299,
      category: 'Home',
    ),
    ServiceModel(
      name: 'Bathroom Cleaning',
      icon: Icons.bathtub_rounded,
      description: 'Descaling of fittings and anti-bacterial scrub.',
      estimatedDuration: '1.5 hrs',
      startingPrice: 599,
      category: 'Home',
    ),
    ServiceModel(
      name: 'Sofa Cleaning',
      icon: Icons.chair_rounded,
      description: 'Deep extraction cleaning for stains, dust mites, and odors.',
      estimatedDuration: '2 hrs',
      startingPrice: 399,
      category: 'Home',
    ),

    // Waterless Vehicle Care
    ServiceModel(
      name: 'Waterless Polish Wash',
      icon: Icons.directions_car_rounded,
      description: 'Premium exterior detailing with a high-gloss finish.',
      estimatedDuration: '1 hr',
      startingPrice: 299,
      category: 'Vehicle',
    ),
    ServiceModel(
      name: 'Waterless Full Care',
      icon: Icons.car_repair_rounded,
      description: 'Exterior wax wash, interior vacuuming, & dashboard conditioning.',
      estimatedDuration: '2 hrs',
      startingPrice: 499,
      category: 'Vehicle',
    ),
    ServiceModel(
      name: 'Two-Wheeler Detail',
      icon: Icons.moped_rounded,
      description: 'Quick and thorough detailing for bikes and scooters.',
      estimatedDuration: '45 mins',
      startingPrice: 149,
      category: 'Vehicle',
    ),

    // Fabric Care & Laundry
    ServiceModel(
      name: 'Wash & Fold',
      icon: Icons.local_laundry_service_rounded,
      description: 'Cleaned with premium detergents, neatly folded and packed.',
      estimatedDuration: '24 hrs',
      startingPrice: 49,
      category: 'Laundry',
    ),
    ServiceModel(
      name: 'Wash & Steam Iron',
      icon: Icons.iron_rounded,
      description: 'Premium wash combined with crisp steam ironing.',
      estimatedDuration: '24 hrs',
      startingPrice: 79,
      category: 'Laundry',
    ),
    ServiceModel(
      name: 'Premium Dry Cleaning',
      icon: Icons.dry_cleaning_rounded,
      description: 'Expert care for delicate fabrics using eco-safe solvents.',
      estimatedDuration: '48 hrs',
      startingPrice: 199,
      category: 'Laundry',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Explore Services', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(service.icon, color: AppTheme.primaryColor, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              service.name,
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              service.category,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.subtleColor),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Starting from',
                                style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.subtleColor),
                              ),
                              Text(
                                '₹${service.startingPrice.toInt()}${service.category == 'Laundry' ? '/kg' : ''}',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (c) => ServiceDetailScreen(service: service)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('View Details', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
