import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../core/app_theme.dart';
import '../../services/api_service.dart';
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
          backgroundColor: Colors.white,
          indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.1),
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

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isLoading = true;
  final Map<String, dynamic> _stats = {
    'usersCount': 1240,
    'revenue': 85000,
    'bookingsCount': 420,
    'activeAlerts': 2,
  };

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    // Simulate real-time data fetch for premium feel
    await Future.delayed(800.ms);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF020617)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 120),
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
                      'SYSTEM NUCLEUS',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'Operational Health',
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
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.security_rounded, color: AppTheme.primaryColor, size: 28),
                ).animate().scale(delay: 200.ms),
              ],
            ),

            const SizedBox(height: 40),
            
            // Real-time Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatTile('TOTAL USERS', '1.2k', Icons.people_rounded, Colors.blueAccent),
                _buildStatTile('GROSS REV', '₹85k', Icons.payments_rounded, Colors.greenAccent),
                _buildStatTile('PENDING', '14', Icons.hourglass_empty_rounded, Colors.orangeAccent),
                _buildStatTile('SYSTEM LOAD', '12%', Icons.memory_rounded, Colors.purpleAccent),
              ],
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

            const SizedBox(height: 40),
            Text(
              'OPERATIONAL ALERTS',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white30, letterSpacing: 2),
            ),
            const SizedBox(height: 20),
            _buildAlertCard('AWS SYNC', 'Database sync completed successfully', Icons.check_circle_rounded, Colors.greenAccent),
            _buildAlertCard('NODE LAG', 'High latency detected in AP-South-1', Icons.warning_amber_rounded, Colors.orangeAccent),

            const SizedBox(height: 40),
            if (kDebugMode)
              _buildDevPortalSwitcher(context).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          Text(label, style: GoogleFonts.outfit(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String title, String msg, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(msg, style: GoogleFonts.outfit(color: Colors.white30, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevPortalSwitcher(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.developer_mode_rounded, color: Colors.orangeAccent, size: 16),
              const SizedBox(width: 12),
              Text(
                'NEXUS GATEWAY (DEMO)',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const MainNavigationScreen())),
              icon: const Icon(Icons.home_outlined),
              label: const Text('RETURN TO CUSTOMER VIEW'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 20),
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
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: Text('USER DIRECTORY', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 15,
        itemBuilder: (context, index) => _buildUserTile(index),
      ),
    );
  }

  Widget _buildUserTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
            child: const Icon(Icons.person_outline_rounded, color: AppTheme.secondaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premium User #${1000 + index}', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('+91 9988776655', style: GoogleFonts.outfit(color: Colors.white30, fontSize: 10)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.1);
  }
}

class AdminProvidersPage extends StatelessWidget {
  const AdminProvidersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: Text('PARTNER PERFORMANCE', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        itemBuilder: (context, index) => _buildPartnerCard(index),
      ),
    );
  }

  Widget _buildPartnerCard(int index) {
    final names = ['Sunil Maharaj', 'Rahul Sharma', 'Amit Patel', 'Vikram Singh', 'Deepak Rao'];
    final ratings = ['4.9', '4.7', '4.8', '4.5', '4.9'];
    final status = ['REACHED PICKUP', 'ON THE WAY', 'JOB STARTED', 'COMPLETED', 'ON THE WAY'];
    final statusColors = [Colors.greenAccent, Colors.orangeAccent, Colors.blueAccent, Colors.purpleAccent, Colors.orangeAccent];
    final jobs = ['124', '89', '210', '45', '167'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white10,
                child: Text(names[index][0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(names[index], style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(ratings[index], style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),
                        const SizedBox(width: 12),
                        Text('${jobs[index]} Jobs Done', style: GoogleFonts.outfit(color: Colors.white30, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: statusColors[index].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(status[index], style: GoogleFonts.outfit(color: statusColors[index], fontSize: 9, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPartnerMetric('Reliability', '99%'),
              _buildPartnerMetric('On-Time', '96%'),
              _buildPartnerMetric('Feedback', 'Good'),
              TextButton(
                onPressed: () {},
                child: Text('MONITOR', style: GoogleFonts.outfit(color: AppTheme.primaryColor, fontWeight: FontWeight.w900, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
  }

  Widget _buildPartnerMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w900)),
        Text(value, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});
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
            child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blueAccent, size: 48),
          ),
          const SizedBox(height: 32),
          Text(
            'ADMIN NUCLEUS',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'System Administration Portal',
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
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('LOGOUT SYSTEM'),
            ),
          ),
        ],
      ),
    );
  }
}
