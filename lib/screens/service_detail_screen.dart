import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_model.dart';
import '../core/app_theme.dart';
import 'booking_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final bool isVehicle = service.category == 'Vehicle';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header with Icon Showcase
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primaryColor, Color(0xFF00E676)],
                  ),
                ),
                child: Center(
                  child: Icon(service.icon, size: 100, color: Colors.white),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    service.name,
                    style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: GoogleFonts.outfit(fontSize: 16, color: AppTheme.subtleColor),
                  ),
                  const SizedBox(height: 32),

                  // Info Cards (Price & Time)
                  Row(
                    children: [
                      _buildInfoCard(Icons.timer_rounded, service.estimatedDuration, 'Duration'),
                      const SizedBox(width: 16),
                      _buildInfoCard(Icons.payments_rounded, '₹${service.startingPrice.toInt()}', 'Starting Price'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Service Requirements (Unique Feature)
                  Text(
                    'What involves?',
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildRequirementItem(
                    Icons.inventory_2_rounded,
                    'BlinKlean Provides',
                    isVehicle 
                        ? 'Specialized Waterless Spray, High-GSM Microfiber cloths, and tire detailer.'
                        : (service.category == 'Laundry' 
                            ? 'Premium eco-detergents and individual hygienic machines.'
                            : 'Our basic tool kit and specialized expertise.'),
                    true,
                  ),
                  const SizedBox(height: 12),
                  _buildRequirementItem(
                    Icons.engineering_rounded,
                    'Customer Provides',
                    isVehicle 
                        ? 'Safe parking space. (100% Water & Electricity Free)'
                        : (service.category == 'Laundry'
                            ? 'The clothes and any special instructions for delicate items.'
                            : 'Water, Electricity, and all required cleaning liquids.'),
                    false,
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => BookingScreen(service: service))),
            child: const Text('Proceed to Book'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(IconData icon, String title, String desc, bool isBlink) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBlink ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isBlink ? Colors.green : Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(fontSize: 13, color: Colors.black.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
