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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // Animated Header with 3D Effect
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    // Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // 3D Icon Container
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: service.buildIcon(
                              size: 60,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              service.category,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F4F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Name Card with 3D effect
                    _build3DCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.shortDescription,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: AppTheme.subtleColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Price & Duration Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.access_time_rounded,
                            service.estimatedDuration,
                            'Duration',
                            const Color(0xFF7C4DFF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.currency_rupee_rounded,
                            service.formattedPrice,
                            'Starting',
                            const Color(0xFF00C853),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // About Section
                    _buildSectionTitle(
                      'About This Service',
                      Icons.info_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _build3DCard(
                      child: Text(
                        service.fullDescription,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: AppTheme.subtleColor,
                          height: 1.7,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // What's Included
                    _buildSectionTitle(
                      "What's Included",
                      Icons.check_circle_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _build3DCard(
                      padding: 0,
                      child: Column(
                        children: service.whatsIncluded
                            .asMap()
                            .entries
                            .map<Widget>((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check_rounded,
                                            color: AppTheme.primaryColor,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            item,
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index < service.whatsIncluded.length - 1)
                                    Divider(
                                      height: 1,
                                      indent: 50,
                                      color: Colors.grey.shade200,
                                    ),
                                ],
                              );
                            })
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Customer Responsibilities
                    _buildSectionTitle(
                      'Customer Responsibilities',
                      Icons.assignment_ind_rounded,
                    ),
                    const SizedBox(height: 12),
                    _build3DCard(
                      child: Column(
                        children: _getCustomerResponsibilities().map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFF9800,
                                    ).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    color: const Color(0xFFFF9800),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        item['desc'] as String,
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          color: AppTheme.subtleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // How It Works
                    _buildSectionTitle('How It Works', Icons.timeline_rounded),
                    const SizedBox(height: 12),
                    _buildHowItWorks(),

                    const SizedBox(height: 24),

                    // Important Notes
                    _buildSectionTitle(
                      'Important Notes',
                      Icons.warning_amber_rounded,
                    ),
                    const SizedBox(height: 12),
                    _build3DCard(
                      child: Column(
                        children: _getImportantNotes().map((note) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFFFF9800),
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    note,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppTheme.subtleColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Trust Badges
                    _buildTrustBadges(),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomBar(context),
    );
  }

  Widget _build3DCard({required Widget child, double padding = 20}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppTheme.subtleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {
        'icon': Icons.app_registration_rounded,
        'title': 'Book Service',
        'desc': 'Select service & schedule',
      },
      {
        'icon': Icons.confirmation_number_rounded,
        'title': 'Get OTP',
        'desc': 'Receive booking confirmation',
      },
      {
        'icon': Icons.home_rounded,
        'title': 'Expert Arrives',
        'desc': 'Professional at your door',
      },
      {
        'icon': Icons.verified_rounded,
        'title': 'Service Done',
        'desc': 'Share OTP & relax',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.secondaryColor,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      step['title'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      step['desc'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        color: AppTheme.subtleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (index < steps.length - 1)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 2,
                        color: Colors.grey.shade200,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getCustomerResponsibilities() {
    switch (service.category) {
      case 'Vehicle Care':
        return [
          {
            'icon': Icons.local_parking_rounded,
            'title': 'Safe Parking Space',
            'desc': 'Ensure vehicle is parked safely for access',
          },
          {
            'icon': Icons.water_drop_outlined,
            'title': 'No Water Needed',
            'desc': 'Our service is 100% waterless',
          },
          {
            'icon': Icons.access_time_rounded,
            'title': 'Be Available',
            'desc': 'Someone should be present during service',
          },
        ];
      case 'Laundry':
        return [
          {
            'icon': Icons.checkroom_rounded,
            'title': 'Provide Clothes',
            'desc': 'Keep clothes ready for pickup',
          },
          {
            'icon': Icons.note_alt_rounded,
            'title': 'Special Instructions',
            'desc': 'Inform about delicate fabrics or stains',
          },
          {
            'icon': Icons.lock_rounded,
            'title': 'Secure Valuables',
            'desc': 'Remove valuables from pockets',
          },
        ];
      case 'Home Cleaning':
        return [
          {
            'icon': Icons.water_drop_rounded,
            'title': 'Water Access',
            'desc': 'Provide water connection for cleaning',
          },
          {
            'icon': Icons.electrical_services_rounded,
            'title': 'Electricity',
            'desc': 'Ensure power supply is available',
          },
          {
            'icon': Icons.door_front_door_rounded,
            'title': 'Clear Access',
            'desc': 'Clear the area to be cleaned',
          },
        ];
      default:
        return [
          {
            'icon': Icons.water_drop_rounded,
            'title': 'Water Access',
            'desc': 'Provide water connection',
          },
          {
            'icon': Icons.electrical_services_rounded,
            'title': 'Electricity',
            'desc': 'Ensure power supply',
          },
          {
            'icon': Icons.access_time_rounded,
            'title': 'Be Available',
            'desc': 'Someone should be present',
          },
        ];
    }
  }

  List<String> _getImportantNotes() {
    switch (service.category) {
      case 'Vehicle Care':
        return [
          'Service is 100% waterless - no water connection required',
          'Final price may vary based on vehicle condition',
          'Please ensure vehicle keys are available',
          'Service does not include engine bay cleaning',
        ];
      case 'Laundry':
        return [
          'Delicate garments may require additional care charges',
          'Stain removal is not guaranteed for old stains',
          'Lost buttons or damaged zippers are not our responsibility',
          'Turnaround time starts from next working day',
        ];
      case 'Home Cleaning':
        return [
          'Please secure pets before service begins',
          'Valuables should be kept in locked cabinets',
          'Service does not include deep carpet cleaning unless booked',
          'Heavy stain removal may require additional treatment',
        ];
      default:
        return [
          'Service time may vary based on property condition',
          'Please ensure someone is available to guide the expert',
          'Final pricing may change based on actual requirements',
        ];
    }
  }

  Widget _buildTrustBadges() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose BlinKlean?',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadge(
                Icons.verified_rounded,
                'Trained\nProfessionals',
                const Color(0xFF00C853),
              ),
              _buildBadge(
                Icons.security_rounded,
                'Background\nVerified',
                const Color(0xFF2979FF),
              ),
              _buildBadge(
                Icons.eco_rounded,
                'Eco-Friendly\nProducts',
                const Color(0xFF7C4DFF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppTheme.subtleColor,
                    ),
                  ),
                  Text(
                    service.formattedPrice,
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => BookingScreen(service: service),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Book Now',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
