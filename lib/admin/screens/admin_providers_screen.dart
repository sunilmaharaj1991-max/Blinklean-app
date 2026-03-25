import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../admin_theme.dart';
import '../models/admin_models.dart';

class AdminProvidersScreen extends StatefulWidget {
  const AdminProvidersScreen({super.key});

  @override
  State<AdminProvidersScreen> createState() => _AdminProvidersScreenState();
}

class _AdminProvidersScreenState extends State<AdminProvidersScreen> {
  final List<ProviderAdminModel> _allProviders =
      ProviderAdminModel.demoProviders();
  String _searchQuery = '';
  String _statusFilter = 'all';

  List<ProviderAdminModel> get _filteredProviders {
    var providers = _allProviders;
    if (_statusFilter != 'all') {
      providers = providers.where((p) => p.status == _statusFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      providers = providers
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.phone.contains(_searchQuery) ||
                p.services.any(
                  (s) => s.toLowerCase().contains(_searchQuery.toLowerCase()),
                ),
          )
          .toList();
    }
    return providers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildStatsBar(),
          _buildFilters(),
          Expanded(child: _buildProvidersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProviderDialog(),
        backgroundColor: AdminTheme.primaryColor,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: Text(
          'Add Provider',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                'Service Providers',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_allProviders.length} providers registered',
                style: GoogleFonts.outfit(color: AdminTheme.subtleColor),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AdminTheme.successColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: AdminTheme.successColor,
                      size: 10,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_allProviders.where((p) => p.status == 'online').length} Online',
                      style: GoogleFonts.outfit(
                        color: AdminTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              '${_allProviders.length}',
              Icons.people_rounded,
              AdminTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Verified',
              '${_allProviders.where((p) => p.isVerified).length}',
              Icons.verified_rounded,
              AdminTheme.successColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Avg Rating',
              '${(_allProviders.map((p) => p.rating).reduce((a, b) => a + b) / _allProviders.length).toStringAsFixed(1)}★',
              Icons.star_rounded,
              AdminTheme.warningColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Total Jobs',
              '${_allProviders.map((p) => p.totalJobs).reduce((a, b) => a + b)}',
              Icons.work_rounded,
              AdminTheme.accentPurple,
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

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AdminTheme.subtleColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search providers...',
                        hintStyle: GoogleFonts.outfit(
                          color: AdminTheme.subtleColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _statusFilter,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text('All Status', style: GoogleFonts.outfit()),
                ),
                DropdownMenuItem(
                  value: 'online',
                  child: Text('Online', style: GoogleFonts.outfit()),
                ),
                DropdownMenuItem(
                  value: 'offline',
                  child: Text('Offline', style: GoogleFonts.outfit()),
                ),
              ],
              onChanged: (v) => setState(() => _statusFilter = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    if (_filteredProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.engineering_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No providers found',
              style: GoogleFonts.outfit(color: AdminTheme.subtleColor),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredProviders.length,
      itemBuilder: (context, index) =>
          _buildProviderCard(_filteredProviders[index]),
    );
  }

  Widget _buildProviderCard(ProviderAdminModel provider) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AdminTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      provider.name[0],
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AdminTheme.primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: provider.status == 'online'
                            ? AdminTheme.successColor
                            : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (provider.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            color: AdminTheme.primaryColor,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AdminTheme.warningColor,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${provider.rating}',
                          style: GoogleFonts.outfit(
                            color: AdminTheme.subtleColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          ' • ${provider.completedJobs} jobs',
                          style: GoogleFonts.outfit(
                            color: AdminTheme.subtleColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: provider.services
                .take(2)
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AdminTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: AdminTheme.primaryColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${provider.earnings.toStringAsFixed(0)}',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AdminTheme.primaryColor,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  _buildActionBtn(Icons.visibility_rounded, () {}),
                  const SizedBox(width: 8),
                  _buildActionBtn(Icons.edit_rounded, () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AdminTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AdminTheme.subtleColor),
      ),
    );
  }

  void _showAddProviderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Provider',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Add Provider')),
        ],
      ),
    );
  }
}
