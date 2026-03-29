import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../core/app_theme.dart';
import '../main_navigation_screen.dart';

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
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.green),
              ).animate().scale(delay: 400.ms),
            ],
          ),
          const SizedBox(height: 30),
          // Stats Row
          Row(
            children: [
              Expanded(child: _buildStatCard('Active Jobs', '3', Icons.pending_actions_rounded, Colors.orange).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard('Completed', '42', Icons.task_alt_rounded, Colors.green).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2)),
            ],
          ),
          const SizedBox(height: 30),
          if (kDebugMode)
            _buildDevPortalSwitcher(context).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 30),
          Text(
            'Today\'s Schedule',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.1),
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

  Widget _buildDevPortalSwitcher(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.developer_mode_rounded, color: AppTheme.primaryColor, size: 14),
              const SizedBox(width: 8),
              Text(
                'DEV TOOLS',
                style: GoogleFonts.outfit(
                  color: AppTheme.subtleColor,
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
              icon: const Icon(Icons.home_rounded, size: 18),
              label: const Text('Return to Customer App'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Booking History', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        itemBuilder: (context, index) => _buildBookingTile(index),
      ),
    );
  }

  Widget _buildBookingTile(int index) {
    final services = ['Car Detailing', 'Deep Cleaning', 'Laundry Service', 'Scrap Pickup'];
    final status = ['Completed', 'Completed', 'In Progress', 'Completed'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.indigo.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.history_rounded, color: Colors.indigo, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(services[index], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text('Date: 27 Mar 2026', style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: status[index] == 'Completed' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status[index],
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: status[index] == 'Completed' ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
  }
}

class PartnerEarningsPage extends StatelessWidget {
  const PartnerEarningsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Earnings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildEarningsSummary(),
            const SizedBox(height: 30),
            _buildPayoutTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo, Colors.indigo.shade800]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.indigo.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance', style: GoogleFonts.outfit(color: Colors.white70)),
          const SizedBox(height: 5),
          Text('₹12,450.00', style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('This Week', '₹3,200'),
              _buildMiniStat('This Month', '₹45,800'),
            ],
          ),
        ],
      ),
    ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack);
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white60, fontSize: 12)),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPayoutTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Payouts', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ...List.generate(3, (index) => _buildPayoutTile(index)),
      ],
    );
  }

  Widget _buildPayoutTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Payout #PAY-${980 - index}', style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
          Text('₹4,000', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    ).animate().fadeIn(delay: (400 + index * 100).ms);
  }
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
