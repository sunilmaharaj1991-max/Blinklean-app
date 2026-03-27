import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';

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
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Admin Stats
          Row(
            children: [
              Expanded(child: _buildAdminStat('Users', '1,240', Icons.people_outline_rounded, Colors.blue)),
              const SizedBox(width: 15),
              Expanded(child: _buildAdminStat('Revenue', '₹45.2k', Icons.currency_rupee_rounded, Colors.green)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildAdminStat('Services', '18', Icons.category_rounded, Colors.orange)),
              const SizedBox(width: 15),
              Expanded(child: _buildAdminStat('Alerts', '4', Icons.notifications_active_rounded, Colors.red)),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'Recent Activities',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
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
}

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('User Management - Coming Soon'));
}

class AdminProvidersPage extends StatelessWidget {
  const AdminProvidersPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Provider Approvals - Coming Soon'));
}

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('System Settings - Coming Soon'));
}
