import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../core/app_theme.dart';
import '../main_navigation_screen.dart';

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardPage(),
    const AdminUsersPage(),
    const AdminProvidersPage(),
    const AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: Colors.indigo.withValues(alpha: 0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.analytics_rounded), label: 'Stats'),
            NavigationDestination(icon: Icon(Icons.people_rounded), label: 'Users'),
            NavigationDestination(icon: Icon(Icons.handyman_rounded), label: 'Partners'),
            NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Admin'),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Nexus',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo,
                    ),
                  ),
                  Text(
                    'System Overview',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textColor,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.indigo),
              ).animate().scale(delay: 400.ms),
            ],
          ),
          const SizedBox(height: 30),
          // Admin Stats
          Row(
            children: [
              Expanded(child: _buildAdminStat('Users', '1,240', Icons.people_outline_rounded, Colors.blue).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2)),
              const SizedBox(width: 15),
              Expanded(child: _buildAdminStat('Revenue', '₹45.2k', Icons.currency_rupee_rounded, Colors.green).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildAdminStat('Services', '18', Icons.category_rounded, Colors.orange).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2)),
              const SizedBox(width: 15),
              Expanded(child: _buildAdminStat('Alerts', '4', Icons.notifications_active_rounded, Colors.red).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2)),
            ],
          ),
          const SizedBox(height: 30),
          if (kDebugMode)
            _buildDevPortalSwitcher(context).animate().fadeIn(delay: 900.ms),
          const SizedBox(height: 30),
          Text(
            'Recent Activities',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.1),
          const SizedBox(height: 15),
          _buildActivityItem('New Partner Joined', 'Sunil joined as a cleaning provider', '2m ago'),
          _buildActivityItem('Service Updated', 'Deep Cleaning price adjusted', '1h ago'),
          _buildActivityItem('Payment Success', 'Booking #1024 confirmed', '3h ago'),
        ],
      ),
    );
  }

  Widget _buildAdminStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 15),
          Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900)),
          Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String sub, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
            child: const Icon(Icons.bolt, color: AppTheme.secondaryColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text(sub, style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor)),
              ],
            ),
          ),
          Text(time, style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.subtleColor)),
        ],
      ),
    );
  }

  Widget _buildDevPortalSwitcher(BuildContext context) {
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
                'DEV TOOLS',
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainNavigationScreen())),
              icon: const Icon(Icons.home_rounded, size: 18, color: Colors.white),
              label: const Text('Return to Customer App', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Registered Users', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (context, index) => _buildUserTile(index),
      ),
    );
  }

  Widget _buildUserTile(int index) {
    final names = ['Amith K.', 'Priya S.', 'Rajesh V.', 'Sneha M.', 'Jeevan G.'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.indigo.withValues(alpha: 0.1), child: Text(names[index][0])),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[index], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text('User UID: AM-${1000 + index}', style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: Colors.grey),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
  }
}

class AdminProvidersPage extends StatelessWidget {
  const AdminProvidersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Partner Approvals', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        itemBuilder: (context, index) => _buildProviderTile(index),
      ),
    );
  }

  Widget _buildProviderTile(int index) {
    final names = ['Sunil M.', 'Kiran B.', 'Rakesh L.'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.green.withValues(alpha: 0.1), child: const Icon(Icons.handyman_rounded, color: Colors.green)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[index], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text('Status: Pending Verification', style: GoogleFonts.outfit(fontSize: 10, color: Colors.orange)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('Review')),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
  }
}

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Amplify.Auth.signOut(),
            child: const Text('Log Out'),
          )
        ],
      ),
    );
  }
}
