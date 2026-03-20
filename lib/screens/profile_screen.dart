import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
import 'booking_history_screen.dart';
import '../core/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final profile = await _auth.getUserProfile(user.id);
      if (mounted) {
        setState(() {
          _user = profile;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Account Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppTheme.primaryColor, width: 2)),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Image.asset(
                        'assets/images/logo_icon.png',
                        width: 100,
                        height: 100,
                        errorBuilder: (c, e, s) => const Icon(Icons.person_rounded, size: 60, color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_user_rounded, color: Colors.blue, size: 24),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(_user?['name'] ?? 'Guest User', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(_user?['phone'] ?? 'Verified Account', style: GoogleFonts.outfit(color: AppTheme.subtleColor)),

            const SizedBox(height: 40),

            // Profile Stats (Bookings Count)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildStatCard('Bookings', '${_user?['bookingsCount'] ?? 0}', Icons.history_rounded),
                  const SizedBox(width: 16),
                  _buildStatCard('Wallet', '₹0.00', Icons.account_balance_wallet_rounded),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Profile Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                   _buildListTile(Icons.location_on_outlined, 'Service Address', _user?['address'] ?? 'No address set', () {}),
                   _buildListTile(Icons.history_rounded, 'My Booking History', 'Manage your existing service schedules.', () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => BookingHistoryScreen()));
                   }),
                   _buildListTile(Icons.pin_drop_rounded, 'Change Service Pin', 'Update your current location gate.', () {
                      AppState().clearLocation();
                   }),
                   const SizedBox(height: 40),
                   SizedBox(
                     width: double.infinity,
                     height: 56,
                     child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white, shadowColor: Colors.transparent),
                        label: const Text('Sign Out'),
                        icon: const Icon(Icons.logout_rounded),
                        onPressed: () => _auth.signOut(),
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(height: 12),
            Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade100)),
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: GoogleFonts.outfit(color: AppTheme.subtleColor, fontSize: 13)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.subtleColor),
      ),
    );
  }
}
