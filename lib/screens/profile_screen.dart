import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../core/app_theme.dart';
import '../widgets/premium_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/brand_logo.dart';
import 'admin/admin_navigation_screen.dart';
import 'provider/partner_navigation_screen.dart';
import 'booking_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Guest User';
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _loadUserAttributes();
  }

  Future<void> _loadUserAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (var attr in attributes) {
        if (attr.userAttributeKey == AuthUserAttributeKey.name) {
          setState(() => _userName = attr.value);
        } else if (attr.userAttributeKey == AuthUserAttributeKey.phoneNumber) {
          setState(() => _userPhone = attr.value);
        }
      }
    } catch (e) {
      debugPrint('Error loading user attributes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // Premium Profile Header
                _buildModernHeader()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.1, end: 0),

                const SizedBox(height: 24),

                // Quick Stats Section (Modernized)
                _buildQuickStats()
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideX(begin: 0.1, end: 0),

                const SizedBox(height: 32),

                // Account Section
                _buildModernSection(
                  'Account Settings',
                  [
                    _buildModernMenuItem(
                      Icons.history_rounded,
                      'Booking History',
                      'View your past sessions',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => const BookingHistoryScreen()),
                      ),
                    ),
                    _buildModernMenuItem(
                      Icons.location_on_outlined,
                      'My Addresses',
                      'Delivery locations',
                      () {},
                    ),
                    _buildModernMenuItem(
                      Icons.logout_rounded,
                      'Sign Out',
                      'Securely log out',
                      _handleSignOut,
                      isDestructive: true,
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 24),

                // Preferences Section
                _buildModernSection(
                  'Preferences',
                  [
                    _buildModernMenuItem(
                      Icons.notifications_outlined,
                      'Notifications',
                      'Alerts & updates',
                      () {},
                    ),
                    _buildModernMenuItem(
                      Icons.dark_mode_rounded,
                      'Appearance',
                      'Glassmorphic theme',
                      () {},
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 24),

                // Dev Portal (if debug)
                if (kDebugMode)
                  _buildPortalSwitcher().animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 48),

                // Footer Brand
                Column(
                  children: [
                    const BrandLogo(size: 32, iconOnly: true)
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 3.seconds, color: Colors.white24),
                    const SizedBox(height: 12),
                    Text(
                      'BLINKLEAN v1.0.0',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white24,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black45,
                  child: Icon(Icons.person_rounded, size: 40, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userPhone.isNotEmpty ? _userPhone : 'Premium Member',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_note_rounded, color: AppTheme.secondaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatItem('Bookings', '12', Icons.calendar_today_rounded),
        const SizedBox(width: 12),
        _buildStatItem('Saved', '4', Icons.favorite_border_rounded),
        const SizedBox(width: 12),
        _buildStatItem('Points', '450', Icons.stars_rounded),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppTheme.secondaryColor.withValues(alpha: 0.7)),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: Colors.white38,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Colors.white24,
              letterSpacing: 2,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildModernMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? Colors.redAccent.withValues(alpha: 0.1) 
                      : AppTheme.secondaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon, 
                  color: isDestructive ? Colors.redAccent : AppTheme.secondaryColor, 
                  size: 20
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isDestructive ? Colors.redAccent : Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white10,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.white10),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to end your current session?',
            style: GoogleFonts.outfit(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.white38)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(c, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Logout', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
    if (confirm == true) {
      await Amplify.Auth.signOut();
    }
  }

  Widget _buildPortalSwitcher() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      color: Colors.black54,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.developer_mode_rounded, color: Colors.orangeAccent, size: 14),
              const SizedBox(width: 8),
              Text(
                'DEV PORTAL',
                style: GoogleFonts.outfit(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPortalBtn('Partner', Colors.greenAccent, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PartnerNavigationScreen()));
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPortalBtn('Admin', Colors.indigoAccent, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminNavigationScreen()));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortalBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
