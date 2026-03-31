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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF020617), // Premium dark background
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PARTNER NEXUS',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.secondaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'Welcome back, Sunil',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.verified_rounded, color: AppTheme.secondaryColor, size: 28),
                ).animate().scale(delay: 200.ms),
              ],
            ),

            const SizedBox(height: 40),

            // Performance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00AEEF), Color(0xFF14B351)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SERVICE RATING', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.yellowAccent, size: 24),
                              const SizedBox(width: 8),
                              Text('4.9/5.0', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                        child: Text('TOP RATED', style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStatCard('JOBS DONE', '124', Icons.task_alt_rounded),
                      _buildMiniStatCard('EARNINGS', '₹45k', Icons.wallet_rounded),
                      _buildMiniStatCard('ACCURACY', '98%', Icons.gps_fixed_rounded),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 40),
            Text(
              'ACTIVE ASSIGNMENTS',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white30, letterSpacing: 2),
            ),
            const SizedBox(height: 20),
            
            _buildAssignmentCard(
              'Deep Cleaning',
              '09:30 AM',
              'Greenwood Residency, HSR Layout',
              'CONFIRMED',
              Colors.blueAccent,
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
            
            _buildAssignmentCard(
              'Car Wash (Waterless)',
              '02:15 PM',
              'Prestige Apartments, Koramangala',
              'PENDING',
              Colors.orangeAccent,
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),

            const SizedBox(height: 32),
            if (kDebugMode)
              _buildDevPortalSwitcher(context).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
        Text(label, style: GoogleFonts.outfit(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildAssignmentCard(String service, String time, String location, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.cleaning_services_rounded, color: statusColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service, style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, color: Colors.white30, size: 14),
                    const SizedBox(width: 4),
                    Text(time, style: GoogleFonts.outfit(color: Colors.white30, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined, color: Colors.white30, size: 14),
                    const SizedBox(width: 4),
                    Expanded(child: Text(location, style: GoogleFonts.outfit(color: Colors.white30, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(status, style: GoogleFonts.outfit(color: statusColor, fontSize: 10, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  Widget _buildDevPortalSwitcher(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.developer_mode_rounded, color: Colors.orangeAccent, size: 16),
              const SizedBox(width: 12),
              Text(
                'SYSTEM ANALYTICS (DEMO)',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainNavigationScreen())),
              icon: const Icon(Icons.home_outlined),
              label: const Text('SWITCH TO CUSTOMER NUCLEUS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: Text('SERVICE HISTORY', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 8,
        itemBuilder: (context, index) => _buildBookingTile(index),
      ),
    );
  }

  Widget _buildBookingTile(int index) {
    final services = ['Car Detailing', 'Deep Cleaning', 'Laundry Service', 'Scrap Pickup'];
    final status = ['COMPLETED', 'CANCELLED', 'COMPLETED', 'COMPLETED'];
    final colors = [Colors.greenAccent, Colors.redAccent, Colors.greenAccent, Colors.greenAccent];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: colors[index % 4].withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.history_toggle_off_rounded, color: colors[index % 4], size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(services[index % 4], style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Date: 27 Mar 2026 • ₹499', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(
            status[index % 4],
            style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: colors[index % 4]),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
  }
}

class PartnerEarningsPage extends StatelessWidget {
  const PartnerEarningsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: Text('EARNINGS PORTAL', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildEarningsSummary(),
            const SizedBox(height: 40),
            _buildPayoutTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo, Colors.indigo.shade900]),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.indigo.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SETTLED BALANCE', style: GoogleFonts.outfit(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text('₹12,450.00', style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('THIS WEEK', '₹3,200'),
              _buildMiniStat('TOTAL JOBS', '124'),
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
        Text(label, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w900)),
        Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPayoutTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECENT TRANSACTIONS', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white30, letterSpacing: 2)),
        const SizedBox(height: 20),
        ...List.generate(5, (index) => _buildPayoutTile(index)),
      ],
    );
  }

  Widget _buildPayoutTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settlement #BKL-${980 - index}', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('24 Mar 2026', style: GoogleFonts.outfit(color: Colors.white24, fontSize: 10)),
            ],
          ),
          Text('₹4,000', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.greenAccent, fontSize: 16)),
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
      color: const Color(0xFF020617),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.power_settings_new_rounded, color: Colors.redAccent, size: 48),
          ),
          const SizedBox(height: 32),
          Text(
            'SECURE SESSION',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to end your active session?',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.white30),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Amplify.Auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('END SESSION'),
            ),
          ),
        ],
      ),
    );
  }
}
