import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin_theme.dart';
import '../models/admin_models.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final List<UserAdminModel> _allUsers = UserAdminModel.demoUsers();
  String _searchQuery = '';

  List<UserAdminModel> get _filteredUsers {
    if (_searchQuery.isEmpty) return _allUsers;
    return _allUsers
        .where(
          (u) =>
              u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              u.phone.contains(_searchQuery) ||
              u.email.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildStatsRow(),
          _buildSearchBar(),
          Expanded(child: _buildUsersList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Management',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_allUsers.length} registered customers',
                style: GoogleFonts.outfit(color: AdminTheme.subtleColor),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.secondaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Users',
              '${_allUsers.length}',
              Icons.people_rounded,
              AdminTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Active',
              '${_allUsers.where((u) => u.status == 'active').length}',
              Icons.check_circle_rounded,
              AdminTheme.successColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Total Spent',
              '₹${_allUsers.map((u) => u.totalSpent).reduce((a, b) => a + b).toStringAsFixed(0)}',
              Icons.currency_rupee_rounded,
              AdminTheme.accentOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AdminTheme.subtleColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AdminTheme.subtleColor),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search by name, phone, email...',
                  hintStyle: GoogleFonts.outfit(color: AdminTheme.subtleColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    if (_filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: GoogleFonts.outfit(color: AdminTheme.subtleColor),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) => _buildUserCard(_filteredUsers[index]),
    );
  }

  Widget _buildUserCard(UserAdminModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AdminTheme.secondaryColor.withValues(alpha: 0.1),
            child: Text(
              user.name[0],
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AdminTheme.secondaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_rounded,
                      size: 14,
                      color: AdminTheme.subtleColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user.phone,
                      style: GoogleFonts.outfit(
                        color: AdminTheme.subtleColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.email_rounded,
                      size: 14,
                      color: AdminTheme.subtleColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.email,
                        style: GoogleFonts.outfit(
                          color: AdminTheme.subtleColor,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: user.status == 'active'
                      ? AdminTheme.successColor.withValues(alpha: 0.12)
                      : AdminTheme.errorColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user.status.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: user.status == 'active'
                        ? AdminTheme.successColor
                        : AdminTheme.errorColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${user.totalBookings} bookings',
                style: GoogleFonts.outfit(
                  color: AdminTheme.subtleColor,
                  fontSize: 12,
                ),
              ),
              Text(
                '₹${user.totalSpent.toInt()}',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AdminTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: AdminTheme.subtleColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.message_rounded,
                  color: AdminTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
