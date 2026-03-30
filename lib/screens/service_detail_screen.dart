import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_theme.dart';
import '../models/service_model.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';
import 'booking_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: PremiumBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Immersive Hero Header
              _buildHeroHeader(context),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    _buildStatsRow().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                    const SizedBox(height: 32),

                    // Service Info
                    _buildSectionTitle("Service Highlights"),
                    const SizedBox(height: 16),
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        service.fullDescription,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 32),

                    // Checklist
                    _buildSectionTitle("What's Included"),
                    const SizedBox(height: 16),
                    _buildCheckList(service.whatsIncluded).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 32),

                    // Requirements
                    _buildSectionTitle("Required for Service"),
                    const SizedBox(height: 16),
                    _buildRequirementCard().animate().fadeIn(delay: 800.ms),

                    const SizedBox(height: 140), // Space for bottom sheet
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomBookBar(context),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                service.imageUrl.isNotEmpty
                    ? service.imageUrl
                    : _getCategoryBackground(service.category),
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  service.category.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.secondaryColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                service.name,
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(Icons.access_time_rounded, service.estimatedDuration, Colors.white60),
        const SizedBox(width: 12),
        _buildStatItem(Icons.star_rounded, "4.8 Rating", Colors.orangeAccent),
        const SizedBox(width: 12),
        _buildStatItem(Icons.verified_user_rounded, "Secure", Colors.blueAccent),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white.withValues(alpha: 0.05),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.white30,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildCheckList(List<String> items) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, size: 18, color: AppTheme.secondaryColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRequirementCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      color: Colors.orangeAccent.withValues(alpha: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              service.customerProvides.isNotEmpty 
                  ? service.customerProvides 
                  : "Standard access to the service location.",
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBookBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TOTAL PRICE", style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                Text(service.formattedPrice, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => BookingScreen(service: service))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Book Premium Session', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryBackground(String category) {
    switch (category) {
      case 'Home Cleaning':
        return 'https://images.unsplash.com/photo-1581578731548-c64695cc6954?auto=format&fit=crop&q=80&w=1000';
      case 'Vehicle Care':
        return 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?auto=format&fit=crop&q=80&w=1000';
      case 'Laundry':
        return 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?auto=format&fit=crop&q=80&w=1000';
      default:
        return 'https://images.unsplash.com/photo-1584622741562-58f3c8371301?auto=format&fit=crop&q=80&w=1000';
    }
  }
}
