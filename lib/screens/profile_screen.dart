import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_theme.dart';
import 'admin/admin_navigation_screen.dart';
import 'provider/partner_navigation_screen.dart';
import 'booking_history_screen.dart';

import 'package:amplify_flutter/amplify_flutter.dart';

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
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF009543), Color(0xFF00ADEF)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Profile',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage your account',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.settings_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Profile Avatar
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userName,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _userPhone.isNotEmpty ? _userPhone : 'Authenticated',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5),
                    const SizedBox(height: 24),
                    // Developer Portal Switcher
                    if (kDebugMode) _buildPortalSwitcher(),
                    const SizedBox(height: 24),
                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickAction(
                            Icons.history_rounded,
                            'Bookings',
                            '0',
                          ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickAction(
                            Icons.favorite_rounded,
                            'Favorites',
                            '0',
                          ).animate().fadeIn(delay: 700.ms).slideX(begin: 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickAction(
                            Icons.location_on_rounded,
                            'Addresses',
                            '0',
                          ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuSection('Account', [
                      _buildMenuItem(
                        Icons.history_rounded,
                        'Booking History',
                        'View your past bookings',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const BookingHistoryScreen(),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        Icons.location_on_outlined,
                        'My Addresses',
                        'Manage delivery addresses',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address management coming soon!')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.payment_rounded,
                        'Payment Methods',
                        'Add or remove payment options',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payments are handled during service.')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.logout_rounded,
                        'Sign Out',
                        'Securely log out of your account',
                        () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Logout')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await Amplify.Auth.signOut();
                          }
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildMenuSection('Preferences', [
                      _buildMenuItem(
                        Icons.notifications_outlined,
                        'Notifications',
                        'Manage notification settings',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.language_rounded,
                        'Language',
                        'English',
                        () {},
                      ),
                      _buildMenuItem(
                        Icons.dark_mode_rounded,
                        'Dark Mode',
                        'System default',
                        () {},
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildMenuSection('Support', [
                      _buildMenuItem(
                        Icons.help_outline_rounded,
                        'Help & FAQ',
                        'Get help with your orders',
                        () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'BlinKlean',
                            applicationVersion: '1.0.0',
                            children: [
                              const Text('For help, please contact support@blinklean.com'),
                            ],
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.chat_rounded,
                        'Contact Us',
                        'Reach out to our team',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('WhatsApp Support: +91 999 999 9999')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        Icons.info_outline_rounded,
                        'About BlinKlean',
                        'Learn more about us',
                        () {
                           showModalBottomSheet(
                             context: context,
                             builder: (c) => Container(
                               padding: const EdgeInsets.all(24),
                               child: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Text('About BlinKlean', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                                   const SizedBox(height: 12),
                                   const Text('India\'s 1st AI Powered QuickClean residential and vehicle platform. We specialize in waterless detailing and normal home cleaning.'),
                                 ],
                               ),
                             ),
                           );
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // App Info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.secondaryColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/images/logo_icon.png',
                                  width: 24,
                                  height: 24,
                                  color: Colors.white,
                                  errorBuilder: (c, e, s) => const Icon(
                                    Icons.bolt_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/logo_full.png',
                                    height: 20,
                                    errorBuilder: (c, e, s) => Text(
                                      'BlinKlean',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Version 1.0.0',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: AppTheme.subtleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'India\'s 1st AI Powered QuickClean Platform',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.subtleColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, String count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.outfit(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.subtleColor,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(height: 1, indent: 70, color: Colors.grey.shade100),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
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
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppTheme.subtleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortalSwitcher() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.developer_mode_rounded, color: Colors.orangeAccent, size: 14),
              const SizedBox(width: 8),
              Text(
                'DEV PORTAL SWITCHER',
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPortalTab('Partner', Icons.handyman_rounded, Colors.greenAccent, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PartnerNavigationScreen()));
              }),
              const SizedBox(width: 8),
              _buildPortalTab('Admin', Icons.shield_rounded, Colors.indigoAccent, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AdminNavigationScreen()));
              }),
            ],
          ),
        ],
      ),
    ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildPortalTab(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
