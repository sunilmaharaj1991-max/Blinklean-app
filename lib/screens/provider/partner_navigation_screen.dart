import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../core/app_theme.dart';

class PartnerNavigationScreen extends StatefulWidget {
  const PartnerNavigationScreen({super.key});

  @override
  State<PartnerNavigationScreen> createState() => _PartnerNavigationScreenState();
}

class _PartnerNavigationScreenState extends State<PartnerNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PartnerDashboardPage(),
    const PartnerBookingsPage(),
    const PartnerEarningsPage(),
    const PartnerSettingsPage(),
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
          indicatorColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.list_alt_rounded), label: 'Bookings'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Earnings'),
            NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class PartnerDashboardPage extends StatelessWidget {
  const PartnerDashboardPage({super.key});

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
                    'Partner Dashboard',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.subtleColor,
                    ),
                  ),
                  Text(
                    'Welcome, Sunil!',
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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Stats Row
          Row(
            children: [
              Expanded(child: _buildStatCard('Active Jobs', '3', Icons.pending_actions_rounded, Colors.orange)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard('Completed', '42', Icons.task_alt_rounded, Colors.green)),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'Today\'s Schedule',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          _buildJobCard('Deep House Cleaning', '10:00 AM', 'HSR Layout', 'Confirmed'),
          _buildJobCard('Car Wash (Waterless)', '02:30 PM', 'Koramanagla', 'Pending'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 15),
          Text(value, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900)),
          Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor)),
        ],
      ),
    );
  }

  Widget _buildJobCard(String service, String time, String area, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.cleaning_services_outlined, color: AppTheme.secondaryColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text('$time • $area', style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.subtleColor)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Confirmed' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: status == 'Confirmed' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerBookingsPage extends StatelessWidget {
  const PartnerBookingsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Bookings History - Coming Soon'));
}

class PartnerEarningsPage extends StatelessWidget {
  const PartnerEarningsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Earnings Dashboard - Coming Soon'));
}

class PartnerSettingsPage extends StatelessWidget {
  const PartnerSettingsPage({super.key});
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
